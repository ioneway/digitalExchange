//
//  LastVersionRequestModel.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/26.
//  Copyright © 2017年 王伟. All rights reserved.
//

import Foundation
import ObjectMapper


class LastVersionRequestModel : Mappable {
    required init?(map: Map) {}
    
    var status: Int = 0
    var timestamp: Int = 0
    var data:LastVersionModel?
    
    func mapping(map: Map)
    {
        status <- map["status"]
        timestamp <- map["timestamp"]
        data <- map["data"]
    }
}


class LastVersionModel:  Mappable{
    required init?(map: Map) {}
    
    var versionDesc:String = ""
    var status:String = ""
    var appName:String = ""
    var updateTime:String = ""
    var newestVersion:String = ""
    var forceUpdate:String = ""
    var type:String = ""
    var createTime:String = ""
    var url:String = ""
    
    var debugDescription: String {
        return """
        LastVersionModel：{
        versionDesc: \(versionDesc) \n
        status: \(status) \n
        appName: \(appName) \n
        updateTime: \(updateTime) \n
        newestVersion: \(newestVersion) \n
        forceUpdate: \(forceUpdate) \n
        createTime: \(createTime) \n
        type: \(type) \n
        url: \(url) \n
        }
        """
    }
    
    func mapping(map: Map)
    {
        versionDesc <- map["versionDesc"]
        status <- map["status"]
        appName <- map["appName"]
        updateTime <- map["updateTime"]
        newestVersion <- map["newestVersion"]
        forceUpdate <- map["forceUpdate"]
        createTime <- map["createTime"]
        type <- map["type"]
        url <- map["url"]
    }
    
}



