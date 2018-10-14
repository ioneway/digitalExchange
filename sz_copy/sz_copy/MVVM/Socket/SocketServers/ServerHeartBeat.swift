//
//  ServerHeartBeat.swift
//  Exchange
//
//  Created by rui on 2018/5/30.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit

struct ServerHeartBeat: SocketServerable {
    var cmd: CmdType = .ping
    var isNeedUserId:Bool = false
    var writeDict: [String : Any] {
        if isNeedUserId {
            return ["cmd":cmd.rawValue,"userId": UserInfo.default.userId ?? 0]
        }
        return ["cmd":cmd.rawValue]
    }
}

