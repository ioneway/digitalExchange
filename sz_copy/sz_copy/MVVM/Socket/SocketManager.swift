//
//  SocketManager.swift
//  Exchange
//
//  Created by rui on 2018/5/30.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
import Gzip
import Alamofire

@objc protocol SocketManagerDelegate {
    @objc optional func socket(didRead data: [String:Any])
        @objc optional  func socket(didReadTick data: [String:Any])
      @objc optional func socket(didReadChart data: [String:Any])
      @objc optional func socket(didReadDepth data: [String:Any])
      @objc optional func socket(didReadExRate data: [String:Any])
     @objc optional  func socket(didReadExTick data: [String:Any])
      @objc optional func socket(didReadExTicBTC data: [String:Any])
      @objc optional func socketError()
}





class SocketManager: NSObject {
    
    private var subscribePool: [String:SocketServerable] = [:]
    
    var heartBeat:Timer?
    
    var reConnectTime: UInt8 = 0 {
        didSet {
            log(reConnectTime)
        }
    }
    
    let concurrentQueue = DispatchQueue(label: "cy", attributes: .concurrent)
    
    weak var delegate: SocketManagerDelegate?
    
    var cacheData: Data = Data()
    
    private lazy var host: String = {
        let server = ServerFactory.default.server(identifier: .cTcp)
        let strs = server.baseurl.components(separatedBy: ":")
        if let host = strs.first {
            return host
        }else {
            fatalError("未获取到c++行情服务器host")
        }
        return ""
    }()

    private lazy var port: UInt16 = {
        let server = ServerFactory.default.server(identifier: .cTcp)
        let strs = server.baseurl.components(separatedBy: ":")
        if let str = strs.last, let port = UInt16(str) {
            return port
        }else {
            fatalError("未获取到c++行情服务器port")
        }
        return 0
    }()
    
    static let shared = SocketManager()
        
    lazy var socket: GCDAsyncSocket = {
        let socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        return socket
    }()
    
    var netIsReachable:Bool = false
    
    private var netMonitor: NetworkReachabilityManager?
    
    private override init() {super.init()
        netMonitor = NetworkReachabilityManager(host: host)
        guard let net = netMonitor else {return}
        netIsReachable = net.isReachable
        net.startListening()
        net.listener = {status in
            if net.isReachable && self.netIsReachable == false {
                self.reCounnect()
            }
            self.netIsReachable = net.isReachable
        }
    }
//
    func subscribe(server: SocketServerable) {
        if var server = server as? SocketSubscribeServerable {
            server.isCancel = false
            if let cacheServer = subscribePool[server.cmd.rawValue] {
                cancelSubscribe(server: cacheServer)
            }
        }
        
//        let paramsStr = server.writeDict.removeValue(forKey: "channel")
        subscribePool.updateValue(server, forKey: server.cmd.rawValue)
        
        write(server: server)
    }
    
    func cancelSubscribe(server: SocketServerable) {
        if var server = server as? SocketSubscribeServerable {
            server.isCancel = true
            write(server: server)
        }
    }
    
    private func write(server: SocketServerable) {
        if self.socket.isDisconnected {
            reCounnect()
            return
        }
        if !self.socket.isConnected {
            return
        }
        guard let data = server.writeData else { return }
        self.socket.write(data, withTimeout: -1, tag: 0)
    }
    
    // MARK: - 处理重连
    private func reCounnect()  {
        if self.socket.isConnected {
            return
        }
        self.destoryHeartBeat()
        self.socket.disconnect()
        log(reConnectTime)
        if (reConnectTime > 64) {
            //您的网络状况不是很好，请检查网络后重试
            reConnectTime = 0
            return;
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2 * TimeInterval(reConnectTime), execute: {
            do {
                try self.socket.connect(toHost: self.host, onPort: self.port)
            }catch {
                log(error)
                self.reCounnect()
                return
            }
        })
        if reConnectTime == 0 {
            reConnectTime = 2
        }else {
            reConnectTime = reConnectTime*2
        }
    }
    
    ///恢复历史的连接
    func weakUp() {
        for obj in self.subscribePool {
            self.write(server: obj.value)
        }
    }
    
    // MARK: - 处理心跳
    func initHeartBeat() {
        let initBeat = {
            self.destoryHeartBeat()
            self.heartBeat = Timer(timeInterval: 30, target: self, selector: #selector(self.sendWriteHeart), userInfo: nil, repeats: true)
            RunLoop.current.add(self.heartBeat!, forMode: RunLoopMode.commonModes)
        }
        if Thread.isMainThread {
            initBeat()
        }else {
            DispatchQueue.main.async{
                initBeat()
            }
        }
    }
    
    @objc func sendWriteHeart() {
        let beat = ServerHeartBeat()
        write(server: beat)
    }
    
    func destoryHeartBeat() {
        let destory = {
            if self.heartBeat != nil {
                self.heartBeat?.invalidate()
                self.heartBeat = nil
            }
        }
        if Thread.isMainThread {
            destory()
        }else {
            DispatchQueue.main.async {
                destory()
            }
        }
    }
}

extension SocketManager: GCDAsyncSocketDelegate {
    
    func process(data: Data, append: Bool = true) {
        
        if append {
            self.cacheData.append(data)
        }else {
            self.cacheData = data
        }
        let cacheData = self.cacheData as NSData
        
        if cacheData.length <= 0 {
            self.socket.readData(withTimeout: -1, tag: 0)
            return
        }
        var i: UInt16 = 0
        if cacheData.length < 14 {
            return
        }
        let headerData = cacheData.subdata(with: NSMakeRange(0, 12))
        let header = String(data: headerData, encoding: .utf8)
        if header != kTcpHeader {
            self.cacheData = Data()
            self.socket.readData(withTimeout: -1, tag: 0)
            return
        }
        cacheData.getBytes(&i, range: NSMakeRange(12, 2))
        let nszie = CFSwapInt16BigToHost(i)
        if nszie > cacheData.length - 18 {
            self.socket.readData(withTimeout: -1, tag: 0)
            return
        }
        
        var dataJson = cacheData.subdata(with: NSMakeRange(14, Int(nszie)))
        if dataJson.isGzipped {
            do {
                dataJson = try dataJson.gunzipped()
            }catch {
                self.cacheData = Data()
                self.socket.readData(withTimeout: -1, tag: 0)
                log(error)
            }
        }
        
        do {
            let dataStr = NSString(data:dataJson ,encoding: String.Encoding.utf8.rawValue) ?? ""
            let jsonData = dataStr.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
            let json=try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)
            log(json)
            
            if let jsonDict = json as? [String:Any],let cmd = jsonDict["cmd"] as? String, let cmdType = CmdType(rawValue: cmd)  {
                if cmdType != .ping {
                    DispatchQueue.main.async {
                        if cmdType == .tick || cmdType == .ticks {
                            self.delegate?.socket?(didReadTick: jsonDict)
                            self.handleTickData(data: jsonDict)
                        }else if cmdType == .depth {
                            self.delegate?.socket?(didReadDepth: jsonDict)
                        }else if cmdType == .chart {
                            self.delegate?.socket?(didReadChart: jsonDict)
                        }else if cmdType == .exRate {
                            self.handleRate(data: jsonDict)
                            self.delegate?.socket?(didReadExRate: jsonDict)
                        }else if cmdType == .exTick {
                            self.delegate?.socket?(didReadExTick: jsonDict)
                        }else if cmdType == .exTicBTC {
                            self.delegate?.socket?(didReadExTicBTC: jsonDict)
                        }else {
                            self.delegate?.socket?(didRead: jsonDict)
                        }
                    }
                }
            }
        } catch {
            self.cacheData = Data()
            self.socket.readData(withTimeout: -1, tag: 0)
            log(error)
        }
        let loc = 14 + Int(nszie) + 4
        let leftData = cacheData.subdata(with: NSMakeRange(loc, cacheData.length - loc))
        process(data: leftData, append: false)
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        reConnectTime = 0
        self.initHeartBeat()
        self.weakUp()
        self.socket.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        self.process(data: data, append: true)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        DispatchQueue.main.async {
            self.reCounnect()
            self.delegate?.socketError?()
        }
    }
    
}

extension SocketManager {
    func handleRate(data: [String:Any]) {
        ///更新法币汇率
//        guard let datas = data["data"] as? [String:Any],let rates = datas["rates"] as? [String:Any], let jsonData = rates.jsonData else {
//            return
//        }
//        EXFileManager.default.writeAsync(data: jsonData, to: .exRatePath) { (flag) in
        
        }
    
    func handleExRate(data: [String:Any]) {
        guard let datas = data["data"] as? [[String:Any]] else {
            return
        }
        //        APPTransactionPair.default.exTickData = datas
    }
    //www---
    func handleExBtcRate(data: [String:Any]) {
        guard let datas = data["data"] as? [String:Any] else {
            return
        }
        //        print(datas)
        //        APPTransactionPair.default.exBtcTickData = datas
    }
    //---www
    
    func handleTickData(data: [String:Any]) {
        guard let datas = data["datas"] as? [String:Any] else {
            return
        }
    }
}
    




