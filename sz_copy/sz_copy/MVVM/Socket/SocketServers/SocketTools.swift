////
////  SocketTools.swift
////  sz_copy
////
////  Created by 王伟 on 2018/11/5.
////  Copyright © 2018 王伟. All rights reserved.
////
//
//import Foundation
//
//class SocketTools: NSObject {
//      static let shared = SocketTools()
//    
//    private lazy var host: String = {
//        let server = ServerFactory.default.server(identifier: .cTcp)
//        let strs = server.baseurl.components(separatedBy: ":")
//        if let host = strs.first {
//            return host
//        }else {
//            fatalError("未获取到c++行情服务器host")
//        }
//        return ""
//    }()
//    
//    private lazy var port: UInt16 = {
//        let server = ServerFactory.default.server(identifier: .cTcp)
//        let strs = server.baseurl.components(separatedBy: ":")
//        if let str = strs.last, let port = UInt16(str) {
//            return port
//        }else {
//            fatalError("未获取到c++行情服务器port")
//        }
//        return 0
//    }()
//    
//    private override init() {
//        super.init()
//        netMonitor = NetworkReachabilityManager(host: host)
//        guard let net = netMonitor else {return}
//        netIsReachable = net.isReachable
//        net.startListening()
//        net.listener = {status in
//            if net.isReachable && self.netIsReachable == false {
//                self.reCounnect()
//            }
//            self.netIsReachable = net.isReachable
//        }
//    }
//}
