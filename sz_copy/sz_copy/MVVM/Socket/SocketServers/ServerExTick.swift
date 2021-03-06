//
//  ServerExTick.swift
//  Exchange
//
//  Created by rui on 2018/6/8.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit
//数字货币兑法币价格, 每次都是全量发送
struct ServerExTick: SocketSubscribeServerable {
    var isCancel: Bool = false
    var cmd: CmdType = .exTick
    
    var symbols: [String] = ["BTC","ETH","EOS"]
    
    var moneys: [String] = ["CNY","USD"]
    
    var writeDict: [String : Any] {
        return ["cmd":cmd.rawValue,"symbols":symbols,"moneys":moneys]
    }
    
}
