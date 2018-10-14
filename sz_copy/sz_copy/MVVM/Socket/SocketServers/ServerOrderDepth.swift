//
//  ServerOrderDepth.swift
//  Exchange
//
//  Created by 孟祥群 on 2018/7/12.
//  Copyright © 2018年 common. All rights reserved.
//

import Foundation
struct ServerOrderDepth: SocketSubscribeServerable {
    var isCancel: Bool = false
    var cmd: CmdType = .orderDepth
    var writeDict: [String : Any] {
        let dict = ["cmd":cmd.rawValue,"userId":UserInfo.default.userId ?? "","orderType":"0"] as [String : Any]
        return dict
    }
}
