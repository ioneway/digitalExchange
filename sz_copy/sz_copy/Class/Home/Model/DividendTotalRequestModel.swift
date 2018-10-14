//
//  GetTodayDividendTotalRequestModel.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/28.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit
import ObjectMapper

class DividendTotalRequestModel: Mappable {
    required init?(map: Map) {}
    init(){}
    
    var status: Int = 0
    var timestamp: Int = 0
    var data: DividendTotalModel?
    
    
    func mapping(map: Map)
    {
        status <- map["status"]
        timestamp <- map["timestamp"]
        data <- map["data"]
    }
}

class DividendTotalModel:  Mappable{
    required init?(map: Map) {}
    init(){}
    var tradeDate:String = ""
    var poundageAmountUsdtTotal = "0.0"
    var dividendUsdtAmountPerM = "0.0"
    var poundageAmountBtcTotal = "0.0"
    var dividendBtcAmountPerM = "0.0"
    var poundageAmountEthTotal = "0.0"
    var dividendEthAmountPerM = "0.0"
    
    var debugDescription: String {
        return """
        GetTodayDividendTotalModel：{
        tradeDate: \(tradeDate) \n
        poundageAmountUsdtTotal: \(poundageAmountUsdtTotal) \n
        dividendUsdtAmountPerM: \(dividendUsdtAmountPerM) \n
        poundageAmountBtcTotal: \(poundageAmountBtcTotal) \n
        dividendBtcAmountPerM: \(dividendBtcAmountPerM) \n
        poundageAmountEthTotal: \(poundageAmountEthTotal) \n
        dividendEthAmountPerM: \(dividendEthAmountPerM) \n
        }
        """
    }
    
    func mapping(map: Map)
    {
        tradeDate <- map["tradeDate"]
        poundageAmountUsdtTotal <- (map["poundageAmountUsdtTotal"], LZDoubleTransform())
        dividendUsdtAmountPerM <- (map["dividendUsdtAmountPerM"], LZDoubleTransform())
        poundageAmountBtcTotal <- (map["poundageAmountBtcTotal"], LZDoubleTransform())
        dividendBtcAmountPerM <- (map["dividendBtcAmountPerM"], LZDoubleTransform())
        poundageAmountEthTotal <- (map["poundageAmountEthTotal"], LZDoubleTransform())
        dividendEthAmountPerM <- (map["dividendEthAmountPerM"], LZDoubleTransform())
    }
}

/*
 {
 "status": 200,
 "timestamp": 1538117152742,
 "data": {
 "tradeDate": "2018-09-28",
 "poundageAmountUsdtTotal": 0,
 "dividendUsdtAmountPerM": 0,
 "poundageAmountBtcTotal": 0,
 "dividendBtcAmountPerM": 0,
 "poundageAmountEthTotal": 0,
 "dividendEthAmountPerM": 0
 }
 }
 */
