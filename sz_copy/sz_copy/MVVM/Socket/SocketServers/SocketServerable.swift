//
//  SocketServerable.swift
//  Exchange
//
//  Created by rui on 2018/5/30.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit

enum CmdType: String {
    case ping = "ping"
    case tick = "tick"
    case ticks = "ticks"
    case depth = "depth"
    case chart = "chart"
    case exRate = "exRate"
    case exTick = "exTick"
    case orderDepth = "order_depth"
    case exTicBTC = "exTicBTC"
}

let kTcpHeader = "magicNyxV0.1"

protocol SocketServerable {
    var cmd: CmdType {get}
    var writeDict: [String:Any] {get}
    var writeData: Data? {get}
}

protocol SocketSubscribeServerable: SocketServerable {
    var isCancel: Bool {set get}
}

extension SocketServerable {
    var writeData: Data? {
        log("socket发送的数据: \(writeDict)")
        var data = kTcpHeader.data(using: .utf8)
        do {
            var jsonData: Data
            if #available(iOS 11.0, *) {
                jsonData =  try JSONSerialization.data(withJSONObject: writeDict, options: .sortedKeys)
            } else {
                jsonData = try JSONSerialization.data(withJSONObject: writeDict, options: .prettyPrinted)
                var str = String(data: jsonData, encoding: .utf8)
                str = str?.replacingOccurrences(of: " ", with: "")
                str = str?.replacingOccurrences(of: "\r\n", with: "")
                str = str?.replacingOccurrences(of: "\r", with: "")
                str = str?.replacingOccurrences(of: "\n", with: "")
                jsonData = (str?.data(using: .utf8))!
            }
            var jsonLength = UInt16(jsonData.count)
            jsonLength = CFSwapInt16BigToHost(jsonLength)
            let jsonLengthData = Data(bytes: &jsonLength, count: 2)
            data?.append(jsonLengthData)
            data?.append(jsonData)
            var crc32 = (data! as NSData).crc32()
            crc32 = CFSwapInt32BigToHost(crc32)
            let swapData = Data(bytes: &crc32, count: 4)
            data?.append(swapData)
        } catch  {
//            dPrint(error)
        }
        return data
    }
}

