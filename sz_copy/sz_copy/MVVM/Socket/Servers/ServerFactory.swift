//
//  ServerFactory.swift
//  Exchange
//
//  Created by rui on 2018/4/17.
//  Copyright © 2018年 common. All rights reserved.
//

import Foundation


class ServerFactory {
    
   var serverStatus: ServerStatus = .szRelese
    
    static let  `default` = ServerFactory()
    
    private init() {
        
    }
    
    func server(identifier: Server) -> Serverable {
        var server: Serverable
        server = createServer(identifier)
        server.serverStatus = self.serverStatus
        return server
    }
    
    func createServer(_ identifier: Server) -> Serverable {
        if identifier == Server.app {
            return AppServer()
        }else if identifier == Server.cTcp {
            return CTcpServer()
        }
        return AppServer()
    } 
    
}
