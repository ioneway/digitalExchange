//
//  ServerExRate.swift
//  Exchange
//
//  Created by rui on 2018/5/30.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit

struct ServerExRate: SocketServerable {
    var cmd: CmdType = .exRate
    var writeDict: [String : Any] {
        return ["cmd":cmd.rawValue]
    }
}
