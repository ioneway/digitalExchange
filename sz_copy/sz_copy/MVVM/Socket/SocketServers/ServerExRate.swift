//
//  ServerExRate.swift
//  Exchange
//
//  Created by rui on 2018/5/30.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit

struct ServerExRate: SocketSubscribeServerable {
    var isCancel: Bool = false
    var cmd: CmdType = .exRate
    var writeDict: [String : Any] {
        return ["cmd":cmd.rawValue]
    }
}
