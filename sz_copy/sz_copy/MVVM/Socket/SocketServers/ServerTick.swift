//
//  ServerTick.swift
//  Exchange
//
//  Created by rui on 2018/5/30.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit

//注册行情数据推送（第一次推送全部数据，后续有推送有变动的）
struct ServerTick: SocketSubscribeServerable {
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
}

