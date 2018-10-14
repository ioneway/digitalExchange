//
//  ExchangeTotalRequestModel.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/28.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit
import ObjectMapper

class ExchangeTotalRequestModel: Mappable {
    required init?(map: Map) {}
    
    var status: Int = 0
    var timestamp: Int = 0
    var data: ExchangeTotalModel?
    
    func mapping(map: Map)
    {
        status <- map["status"]
        timestamp <- map["timestamp"]
        data <- map["data"]
    }
}

class ExchangeTotalModel:  Mappable{
    required init?(map: Map) {}
    
    var id:Int = 0
    var diggingTotal = "0.0"
    var diggingOverTotal = "0.0"
    var diggingYesterdayTotal = "0.0"
    var positionTotal = "0.0"
    var circulationTotal = "0.0"
    var tnFrozenTotal = "0.0"
    var currentTotal = "0.0"
    var totalType:Int = 0
    var createTime:String = ""
    
    var debugDescription: String {
        return """
        ExchangeTotalModel：{
        id: \(id) \n
        diggingTotal: \(diggingTotal) \n
        diggingOverTotal: \(diggingOverTotal) \n
        diggingYesterdayTotal: \(diggingYesterdayTotal) \n
        positionTotal: \(positionTotal) \n
        circulationTotal: \(circulationTotal) \n
        tnFrozenTotal: \(tnFrozenTotal) \n
        currentTotal: \(currentTotal) \n
        totalType: \(totalType) \n
        createTime: \(createTime) \n
        }
        """
    }
    
    func mapping(map: Map)
    {
        id <- map["id"]
        diggingTotal <- (map["diggingTotal"], LZDoubleTransform())
        diggingOverTotal <- (map["diggingOverTotal"], LZDoubleTransform())
        diggingYesterdayTotal <- (map["diggingYesterdayTotal"], LZDoubleTransform())
        positionTotal <- (map["positionTotal"], LZDoubleTransform())
        circulationTotal <- (map["circulationTotal"], LZDoubleTransform())
        tnFrozenTotal <- (map["tnFrozenTotal"], LZDoubleTransform())
        
        currentTotal <- (map["currentTotal"], LZDoubleTransform())
        totalType <- map["totalType"]
        createTime <- map["createTime"]
    }
}
