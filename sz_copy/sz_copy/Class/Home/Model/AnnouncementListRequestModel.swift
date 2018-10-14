//
//  aaaa.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/28.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit
import ObjectMapper

class AnnouncementListRequestModel: Mappable {
    required init?(map: Map) {}
    
    var status: Int = 0
    var timestamp: Int = 0
    var data: [AnnouncementModel]?
    
    func mapping(map: Map)
    {
        status <- map["status"]
        timestamp <- map["timestamp"]
        data <- map["data"]
    }
}

class AnnouncementModel:  Mappable{
    required init?(map: Map) {}
    
    var id:Int = 0
    var title:String = ""
    var url:String = ""
    var state:Int = 0
    var createTime:String = ""     //"2018-08-24 16:31:05"
    var updateTime:String = ""
    
    var debugDescription: String {
        return """
        AnnouncementModel：{
        id: \(id) \n
        title: \(title) \n
        url: \(url) \n
        state: \(state) \n
        createTime: \(createTime) \n
        updateTime: \(updateTime) \n
        }
        """
    }
    
    func mapping(map: Map)
    {
        id <- map["id"]
        title <- map["title"]
        url <- map["url"]
        state <- map["state"]
        url <- map["url"]
        createTime <- map["createTime"]
        updateTime <- map["updateTime"]
    }
}


/*
{
    "status": 200,
    "timestamp": 1538116740530,
    "data": [
    {
    "id": 8,
    "title": "8月31号开放注册",
    "url": "http://www.sz.com",
    "state": 1,
    "createTime": "2018-08-24 16:31:05",
    "updateTime": "2018-09-21 15:56:47"
    },
    {
    "id": 9,
    "title": "注册即送100SZ币",
    "url": "http://www.baidu.com",
    "state": 1,
    "createTime": "2018-08-24 16:32:05",
    "updateTime": "2018-09-13 20:55:57"
    },
    {
    "id": 10,
    "title": "测试3",
    "url": "http://w",
    "state": 1,
    "createTime": "2018-08-29 17:02:40",
    "updateTime": "2018-09-13 20:55:58"
    },
    {
    "id": 11,
    "title": "测试4",
    "url": "http://w",
    "state": 1,
    "createTime": "2018-08-29 17:02:48",
    "updateTime": "2018-09-13 20:55:58"
    },
    {
    "id": 12,
    "title": "测试5",
    "url": "http://1",
    "state": 1,
    "createTime": "2018-08-29 17:02:57",
    "updateTime": "2018-09-13 20:56:00"
    }
    ]
}
*/
