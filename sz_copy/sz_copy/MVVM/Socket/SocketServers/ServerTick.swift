//
//  ServerTick.swift
//  Exchange
//
//  Created by rui on 2018/5/30.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift

//注册行情数据推送（第一次推送全部数据，后续有推送有变动的）
struct TickSocket: SocketSubscribeServerable {
    var isCancel: Bool = false
    var cmd: CmdType = .ticks
    var symbols: [String] = ["BTC_USDT"]
    var writeDict: [String : Any] {
        var dict = ["cmd":cmd.rawValue, "symbols":symbols] as [String : Any]
        var channel = "add"
        if isCancel {
            channel = "del"
        }
        dict.updateValue(channel, forKey: "channel")
       return dict
    }
    
    init(symbols:[String]) {
        self.symbols = symbols
    }
}


/// 行情服务
class TickServer: NSObject, SocketManagerDelegate {
    func socketError() {
        log("socketError")
    }
    
    public var dicVariable : Variable<[String: TickModel]> = Variable<[String: TickModel]>([:])
    static let `default`: TickServer = TickServer()
    
    /// 订阅服务
    func subscriptTick(coinPairs: [String] ) {
        var symbols = [String]()
        for (_, pair) in (coinPairs.enumerated()) {
            let infor = pair.replacingOccurrences(of: "/", with: "_")
            if infor.count != 0 {
                symbols.append(infor)
            }
        }
        let server = TickSocket(symbols: symbols)
        SocketManager.shared.delegate = self
        SocketManager.shared.subscribe(server: server)
    }
    
    /// 取消服务
    func cancelSubscript(coinPairs: [String]) {
        var symbols = [String]()
        for (_, pair) in (coinPairs.enumerated()) {
            let infor = pair.replacingOccurrences(of: "/", with: "_")
            if infor.count != 0 {
                symbols.append(infor)
            }
        }
        var server = TickSocket(symbols: symbols)
        server.symbols = symbols
        SocketManager.shared.cancelSubscribe(server: server)
    }
    
    /// 读取数据代理
    func socket(didReadTick data: [String:Any]) {
        let tickResponse = Mapper<TickRequestModel>().map(JSON: data)
        for model in tickResponse?.datas ?? [] {
            self.dicVariable.value.updateValue(model, forKey: model.symbol)
        }
    }
}
