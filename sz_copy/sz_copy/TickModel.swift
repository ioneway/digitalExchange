//
//  CoinPairModel.swift
//  RxSwiftMVVM
//
//  Created by 王伟 on 2018/9/17.
//  Copyright © 2018年 JianweiWang. All rights reserved.
//
import Foundation
import ObjectMapper
import RealmSwift

class TickRequestModel: Mappable {
    var channel: String = ""
     var cmd: String = ""
     var code: Int = -1
     var datas: [TickModel]?
     var data: TickModel?
     var symbols: [String]?
    var symbol: String = ""
    required init?(map: Map) {}
    
    func mapping(map: Map)
    {
        channel <- map["channel"]
        cmd <- map["cmd"]
        code <- map["code"]
        datas <- map["datas"]
        data <- map["data"]
        symbols <- map["symbols"]
        symbol <- map["symbol"]
        
//        for model in datas ?? [] {
//            if model.name == "" {
//                model.name = symbols?.last ?? ""
//            }
//        }
    }
}

class TickModel: Mappable, CustomDebugStringConvertible{
    @objc  dynamic var  name: String = ""    //名字
    @objc  dynamic var  day_volume: String = "0.00"     //24h量
    @objc  dynamic var  price: String = "0.00" //当前价格
    
    @objc dynamic var  day_open: String = "0.00"  //开盘价
    @objc  dynamic var  day_high: String = "0.00" //最高价
    @objc dynamic var  day_low: String = "0.00"  //最低价
    @objc  dynamic var  day_ts: Double = 0   //时间戳
    @objc  dynamic var  amount: String = "0.00"
    @objc  dynamic var  symbol: String = ""
   
    required convenience init?(map: Map) {
        self.init()
    }
    
     var debugDescription: String {
        return """
        TickModel：{
        name: \(String(describing: name))
        day_volume: \(String(describing: day_volume))
        price: \(String(describing: price))
        money: \(String(describing: money))
        day_open: \(String(describing: day_open))
        day_high: \(String(describing: day_high))
        day_low: \(String(describing: day_low))
        day_ts: \(String(describing: day_ts))
        amount: \(String(describing: amount))
        symbol: \(String(describing: symbol))
        }
        """
    }

    func mapping(map: Map)
    {
        name <- map["name"]
        day_volume <- (map["day_volume"], LZDoubleTransform())
        price <- (map["price"], LZDoubleTransform())
        day_open <- (map["day_open"], LZDoubleTransform())
        day_high <- (map["day_high"], LZDoubleTransform())
        day_low <- (map["day_low"], LZDoubleTransform())
        day_ts <- map["day_ts"]
        amount <- (map["amount"], LZDoubleTransform())
        symbol <- map["symbol"]
        name = symbol
    }
    
    var coinPairFirstName: String? {
        get {
            if self.symbol.contains("_") {
                let strs = self.symbol.components(separatedBy: "_")
                if let first = strs.first {
                    return first
                }
            }
            return nil
        }
    }
    
    var coinPairLastName: String? {
        get {
            if self.symbol.contains("_") {
                let strs = self.symbol.components(separatedBy: "_")
                if let first = strs.last {
                    return first
                }
            }
            return nil
        }
    }
    
    var money: String? {
        get {
            let temp = (APPTransactionPair.default.exTickDatasVariable.value[coinPairLastName ?? ""] ?? 0.decimal) * self.price.decimal
            return temp.string
        }
    }
}
