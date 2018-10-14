//
//  BannerModel.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/26.
//  Copyright © 2018年 王伟. All rights reserved.
//

import Foundation
import ObjectMapper


class BannerRequestModel: Mappable {
    required init?(map: Map) {}
    
    var status: Int = 0
    var timestamp: Int = 0
    var data: [BannerModel]?
    
    
    func mapping(map: Map)
    {
        status <- map["status"]
        timestamp <- map["timestamp"]
        data <- map["data"]
    }
}




class BannerModel: Mappable,  CustomDebugStringConvertible{
    required init?(map: Map) {}
    
    var id:Int = 0
    var type:Int = 0
    var name:String = ""
    var picPath:String = ""
    var url:String = ""
    var sortOrder:Int = 0
    var enabled:Int = 0
    var createdAt:String = ""
    var updatedAt:String = ""
    
   var debugDescription: String {
        return """
        BannerModel：{
        id: \(id) \n
        type: \(type) \n
        name: \(name) \n
        picPath: \(picPath) \n
        url: \(url) \n
        sortOrder: \(sortOrder) \n
        enabled: \(enabled) \n
        createdAt: \(createdAt) \n
        updatedAt: \(updatedAt) \n
        }
        """
    }
    
    func mapping(map: Map)
    {
        id <- map["id"]
        type <- map["type"]
        name <- map["name"]
        picPath <- map["picPath"]
        url <- map["url"]
        sortOrder <- map["sortOrder"]
        enabled <- map["enabled"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
    }
    
}



