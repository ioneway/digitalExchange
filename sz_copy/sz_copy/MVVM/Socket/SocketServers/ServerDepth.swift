//
//  ServerDepth.swift
//  Exchange
//
//  Created by rui on 2018/5/30.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit

//注册深度数据推送（每次推送全部最新）
struct  ServerDepth: SocketSubscribeServerable {
    var cmd: CmdType = .depth
    var isCancel: Bool = false
    var symbol: String = "BTC_USDT"
    var code: Int = 0
    var writeDict: [String : Any] {
        var dict = ["cmd":cmd.rawValue,"symbol":symbol,"code":code] as [String : Any]
        var channel = "add"
        if isCancel {
            channel = "del"
        }
        dict.updateValue(channel, forKey: "channel")
        return dict
    }
}
