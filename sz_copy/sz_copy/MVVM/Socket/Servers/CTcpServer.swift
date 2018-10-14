//
//  CTcpServer.swift
//  Exchange
//
//  Created by rui on 2018/8/6.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit
///行情访问地址
class CTcpServer: Serverable {
    var serverStatus: ServerStatus = .test
    
    var baseurl: String {
        var url = "47.75.144.95:12388"
        switch serverStatus {
        case .relese:
            url = "47.75.144.95:12388"
        case .develop:
            url = "47.75.144.95:12388"
        case .test:
            url = "47.75.136.50:12388"
        case .szDevelop:
            url = "47.97.124.75:12388"
        case .szRelese:
            url = "tcp.mt1733.com:12388"
        case .szTest:
            url = "47.98.65.112:12388"

        }
        return url
    }
    
    var publicKey: String? {
        return nil
    }
    
    var privateKey: String? {
        var privateKey = "20180720"
        switch serverStatus {
        case .relese:
            privateKey = "20180720"
        case .develop:
            privateKey = "20180720"
        case .test:
            privateKey = "20180720"
        case .szDevelop:
            privateKey = "20180720"
        case .szRelese:
            privateKey = "20180720"
        case .szTest:
            privateKey = "20180720"
        }
        return privateKey
    }
    
    var apiVersion: String? {
        return nil;
    }
    
}
