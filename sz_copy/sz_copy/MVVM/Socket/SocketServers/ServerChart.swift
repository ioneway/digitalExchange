//
//  ServerChart.swift
//  Exchange
//
//  Created by rui on 2018/5/30.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit

//注册图表数据推送，period：1 5 60 ...分别代表多少分种间隔的k线
//bar：数量
struct ServerChart: SocketSubscribeServerable {
    var isCancel: Bool = false
    var cmd: CmdType = .chart
    var symbol: String = "BTC_USDT"
    var period: Int = 1
    var bar: Int = 300
    var writeDict: [String : Any] {
        let dict = ["cmd":cmd.rawValue,"period":period,"bar":bar,"symbol":symbol] as [String : Any]
        return dict
    }
}
