//
//  Serverable.swift
//  Exchange
//
//  Created by rui on 2018/4/16.
//  Copyright © 2018年 common. All rights reserved.
//

import Foundation

enum ServerStatus {
    case test
    case relese
    case develop
    case szDevelop
    case szRelese
    case szTest

}

protocol Serverable {
    var serverStatus: ServerStatus {get set}
    var baseurl: String {get}
    var publicKey: String? {get}
    var privateKey: String? {get}
    var apiVersion: String? {get}
}

