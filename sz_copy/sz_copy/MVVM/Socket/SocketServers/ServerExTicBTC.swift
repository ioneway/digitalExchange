//
//  ServerExTick.swift
//  Exchange
//
//  Created by rui on 2018/6/8.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit
//数字货币兑BTC价格
struct ServerExTicBTC: SocketServerable {
    var cmd: CmdType = .exTicBTC
    var channel: String = "add"
    
    var writeDict: [String : Any] {
        return ["cmd":cmd.rawValue,"channel":channel]
    }
    
}
