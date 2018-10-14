//
//  CoinPairModel.swift
//  RxSwiftMVVM
//
//  Created by 王伟 on 2018/9/17.
//  Copyright © 2018年 JianweiWang. All rights reserved.
//
import Foundation
import ObjectMapper

class AllTradeInfoRequireModel: Mappable {
    required init?(map: Map) {}
    
    var status: Int = 0
    var timestamp: Int = 0
    var data: [[String: [[String: Any]]]]?
    
    
    func mapping(map: Map)
    {
        status <- map["status"]
        timestamp <- map["timestamp"]
        data <- map["data"]
    }
}



class TradeInfoModel: Mappable, CustomDebugStringConvertible{
    var id:Int?
    var openTime:String = ""
    var stepSize = "0.00".decimal //数量尺寸
    var minPrice = "0.00".decimal//委托单最低价
    var quoteLeverageLimit = "0.00".decimal //计价货币杠杆限额
    var baseLeverageLimit = "0.00".decimal //交易杠杆限额
    var decimalPlaces:Int = 0 //小数位数
    var merge = "0.00".decimal
    var minQty = "0.00".decimal //最小量
    var tickSize = "0.00".decimal  //价格尺寸
    var leverageTimes:String = "" //杠杆倍数
    var increase = "0.00".decimal
    var checkStr:String = ""
    var closeTime:String = ""
    var sort:Int = 0
    var tradeStatus:Int = 1 //状态锁 1锁 0 没锁可用 第一级
    var maxPrice = "0.00".decimal //委托最高价
    var entrustMaxAmount = "0.00".decimal
    var entrustMinAmount = "0.00".decimal
    var createTime:String = ""
    var maxQty = "0.00".decimal //最大量
    var tradeCode:String = ""
    
    var numberdigit:Int = 8 //数量支持的位数
    var priceDigit:Int = 8 //单价支持的位数
    
    var conventionLock:Int = 1 // 1锁 0 没锁可用 币币锁
    var leverageLock:Int = 1 // 1锁 0 没锁可用 杠杆锁
    
    var limitLock:Int = 1 //1锁 0没锁 限价锁
    var marketLock:Int = 1 //1锁 0 没锁  市价锁
    
    
  var debugDescription: String {
        return """
        TradeInfoModel：{
        id: \(String(describing: id))
        openTime: \(String(describing: openTime))
        stepSize: \(String(describing: stepSize))
        minPrice: \(String(describing: minPrice))
        quoteLeverageLimit: \(String(describing: quoteLeverageLimit))
        baseLeverageLimit: \(String(describing: baseLeverageLimit))
        decimalPlaces: \(String(describing: decimalPlaces))
        merge: \(String(describing: merge))
        minQty: \(String(describing: minQty))
        tickSize: \(String(describing: tickSize))
        
        leverageTimes: \(String(describing: leverageTimes))
        increase: \(String(describing: increase))
        checkStr: \(String(describing: checkStr))
        closeTime: \(String(describing: closeTime))
        sort: \(String(describing: sort))
        tradeStatus: \(String(describing: tradeStatus))
        maxPrice: \(String(describing: maxPrice))
        createTime: \(String(describing: createTime))
        maxQty: \(String(describing: maxQty))
        tradeCode: \(String(describing: tradeCode))
        
        numberdigit: \(String(describing: numberdigit))
        priceDigit: \(String(describing: priceDigit))
        conventionLock: \(String(describing: conventionLock))
        limitLock: \(String(describing: limitLock))
        marketLock: \(String(describing: marketLock))
        entrustMaxAmount: \(String(describing: entrustMaxAmount))
        entrustMinAmount: \(String(describing: entrustMinAmount)) 
        }
        """
    }
    
    
    required init?(map: Map){}
    init() {}
    
    func mapping(map: Map)
    {
        baseLeverageLimit <- (map["baseLeverageLimit"], LZDecimalTransform())
        closeTime <- map["closeTime"]
        createTime <- map["createTime"]
        decimalPlaces <- map["decimalPlaces"]
        id <- map["id"]
        merge <- (map["merge"] , LZDecimalTransform())
        increase <- (map["increase"] , LZDecimalTransform())
        maxPrice <- (map["maxPrice"] , LZDecimalTransform())
        maxQty <- (map["maxQty"], LZDecimalTransform())
        minPrice <- (map["minPrice"], LZDecimalTransform())
        minQty <- (map["minQty"], LZDecimalTransform())
        entrustMaxAmount <- (map["entrustMaxAmount"], LZDecimalTransform())
        entrustMinAmount <- (map["entrustMinAmount"], LZDecimalTransform())
        
        quoteLeverageLimit <- (map["quoteLeverageLimit"], LZDecimalTransform())
        sort <- map["sort"]
        stepSize <- (map["stepSize"], LZDecimalTransform())
        tickSize <- (map["tickSize"], LZDecimalTransform())
        tradeStatus <- map["tradeStatus"]
        leverageTimes <- map["leverageTimes"]
        tradeCode <- map["tradeCode"]
        conventionLock <- map["conventionLock"]
        leverageLock <- map["leverageLock"]
        limitLock <- map["limitLock"]
        marketLock <- map["marketLock"]
    }
    
    
    /// 当前币对是否支持币币交易
    var isSupportCoinTrade: Bool {
        return (self.tradeStatus == 0 && self.conventionLock == 0)
    }
}
