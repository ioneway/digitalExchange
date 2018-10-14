//
//  AppServer.swift
//  Exchange
//
//  Created by rui on 2018/4/16.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit

///API接口服务器
class AppServer: Serverable {
    
    var serverStatus: ServerStatus = .szDevelop
    var baseurl: String {
        var url = "http://35.201.238.6:8080/app-openapi"
        switch serverStatus {
        case .relese:
            url = "http://47.98.139.149:8082"
        case .develop:
            url = "http://47.97.124.75:8091"
        case .test:
            url = "http://47.75.194.232:8082"
        case .szDevelop:
            url = "http://47.98.65.112:8183"
        case .szRelese:
            url = "https://web.mt1733.com"
        case .szTest:
            url = "http://47.98.65.112:8183"
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
