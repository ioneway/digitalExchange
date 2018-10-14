//
//  ServiceSocketManager.swift
//  Exchange
//
//  Created by 孟祥群 on 2018/7/12.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
import Gzip
import Alamofire
protocol ServiceSocketDelegate:class {
    func orderDepth(didRead data: [String:Any])
    func changeOrderStates()
    func closeSocket()
}
class ServiceSocketManager: NSObject {
   private var subscribePool: [String:SocketServerable] = [:]
    
    var heartBeat:Timer?
    
    var currentTime:Int64 = 0
    
    var isLeave:Bool = false
    
    var reConnectTime: UInt8 = 0 {
        didSet {
           log(reConnectTime)
        }
    }
    
    let concurrentQueue = DispatchQueue(label: "cy", attributes: .concurrent)
    
    weak var delegate: ServiceSocketDelegate?
    
    var cacheData: Data = Data()
    
    private lazy var host: String = {
        let server = ServerFactory.default.server(identifier: Server.cTcp)
        let strs = server.baseurl.components(separatedBy: ":")
        if let host = strs.first {
            return host
        }else {
            fatalError("未获取到java行情服务器host")
        }
        return ""
    }()
    
    private lazy var port: UInt16 = {
        let server = ServerFactory.default.server(identifier: Server.cTcp)
        let strs = server.baseurl.components(separatedBy: ":")
        if let str = strs.last, let port = UInt16(str) {
            return port
        }else {
            fatalError("未获取到java行情服务器port")
        }
        return 0
    }()
    
    static let shared = ServiceSocketManager()
    
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
    
    func subscribe(server: SocketServerable) {
        if var server = server as? SocketSubscribeServerable {
            server.isCancel = false
            if let cacheServer = subscribePool[server.cmd.rawValue] {
                cancelSubscribe(server: cacheServer)
            }
        }
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
    
    func closeSocket()  {
        if socket.isConnected {
        socket.disconnect()
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
        var beat = ServerHeartBeat()
        beat.isNeedUserId = true
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

extension ServiceSocketManager: GCDAsyncSocketDelegate {
    
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
//                dPrint(error)
            }
        }
        
        
        do {
            let json = try JSONSerialization.jsonObject(with: dataJson, options: .mutableContainers)
            let str = NSString(data:dataJson ,encoding: String.Encoding.utf8.rawValue)
            log(str)
//            dPrint(json)
            if let jsonDict = json as? [String:Any],let cmd = jsonDict["cmd"] as? String {
                if cmd == "pong" {
                    let time:Int64 = (jsonDict["time"] ?? 0) as! Int64
//                    let time:Int64 = 12123234234234334
                    if currentTime != time {
                        if currentTime != 0 {
                            if self.delegate != nil && self.delegate?.changeOrderStates != nil {
                                self.delegate?.changeOrderStates()
                            }
                        }
                    }
                    currentTime = (jsonDict["time"] ?? 0) as! Int64
                }
            }
            
            
            if let jsonDict = json as? [String:Any],let cmd = jsonDict["cmd"] as? String, let cmdType = CmdType(rawValue: cmd)  {
                if cmdType != .ping {
                    DispatchQueue.main.async {
                        if cmdType == .orderDepth {
                            self.currentTime = 0
                            if self.delegate != nil && self.delegate?.orderDepth != nil {
                                self.delegate?.orderDepth(didRead: jsonDict)
                            }
                        }
                    }
                }
            }
        } catch  {
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
            if self.delegate != nil && self.delegate?.closeSocket != nil {
                self.delegate?.closeSocket()
            }
            
            if !self.isLeave {
            self.reCounnect()
            }
        }
    }
}

