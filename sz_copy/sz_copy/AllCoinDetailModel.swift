//
//  TradeCoinModel.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/21.
//  Copyright © 2018年 王伟. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift


class AllCoinDetailRequestModel : Mappable {
    
    var status: Int?
    var timestamp: Int?
    var data: [AllCoinDetailModel]?
    
    required init?(map: Map) {}
    
    init() {}
    
    func mapping(map: Map)
    {
        status <- map["status"]
        timestamp <- map["timestamp"]
        data <- map["data"]
    }
    
    subscript(coinCode: String) -> AllCoinDetailModel?
    {
        get {
//            let result = data?[coin]
//            return "\(result ?? 0)".decimal
            for  model in data ?? [] {
                if model.coinCode.uppercased() == coinCode.uppercased() {
                    return model
                }
            }
            return nil
        }
    }
}


class AllCoinDetailModel:  Object, Mappable {
    
    //币种代码
    @objc private(set) dynamic var coinCode:String = ""
    //币种名称
    @objc private(set) dynamic var coinFullName = ""
    //币种名称
    @objc private(set) dynamic var coinName = ""
    //是否可以提现
    @objc private(set) dynamic var isdraw: Bool = false
    //是否可以充值
    @objc private(set) dynamic var isrecharge: Bool = false
    //提现最小值
    @objc private(set) dynamic var drawMin = "0.00"
    //提现最大值
    @objc private(set) dynamic var drawMax = "0.00"
    //充值最大值
    @objc private(set) dynamic var rechargeMax = "0.00"
    //充值最小值
    @objc private(set) dynamic var rechargeMin = "0.00"
    //logoUrl
    @objc private(set) dynamic var logoUrl = ""
    //币种精度
    @objc private(set) dynamic var coinPrecision:Int = 0
    //充值最小值
    @objc private(set) dynamic var coinKind = ""

    override var description: String {
        return """
        AllCoinDetailModel：{
            coinCode: \(String(describing: coinCode))
            coinFullName: \(String(describing: coinFullName))
            coinName: \(String(describing: coinName))
            isdraw: \(String(describing: isdraw))
            isrecharge: \(String(describing: isrecharge))
            drawMin: \(String(describing: drawMin))
            isdraw: \(String(describing: isdraw))
            drawMax: \(String(describing: drawMax))
            rechargeMax: \(String(describing: rechargeMax))
            rechargeMin: \(String(describing: rechargeMin))
            coinPrecision: \(String(describing: coinPrecision))
            coinKind: \(String(describing: coinKind))
        }
        """
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map)
    {
        coinCode <- map["coinCode"]
        coinFullName <- map["coinFullName"]
        coinName <- map["coinName"]
        isdraw <- map["isdraw"]
        isrecharge <- map["isrecharge"]
        drawMin <- (map["drawMin"], LZDoubleTransform())
        drawMax <- (map["drawMax"], LZDoubleTransform())
        rechargeMin <- (map["rechargeMin"], LZDoubleTransform())
        rechargeMax <- (map["rechargeMax"], LZDoubleTransform())
        logoUrl <- map["logoUrl"]
        coinPrecision <- map["coinPrecision"]
        coinKind <- map["coinKind"]
        
        format()
    }
    
    /// 数据格式化
    private func format() {
        //最小可充值
        rechargeMin = rechargeMin.decimal.roundStr_down(coinPrecision)
        //最大可充值
        rechargeMax = rechargeMax.decimal.roundStr_down(coinPrecision)
        //最大提现
        drawMax = drawMax.decimal.roundStr_down(coinPrecision)
        //最小提现
        drawMin = drawMin.decimal.roundStr_down(coinPrecision)
    }
    
    
}


/*
 {
 "status": 200,
 "timestamp": 1537790828929,
 "data": [
 {
 "coinCode": "BTC",
 "coinFullName": "BitCoin",
 "coinName": "比特币",
 "isdraw": 1,
 "isrecharge": 1,
 "drawMin": 0.00102038,
 "drawMax": 10000,
 "rechargeMin": 1,
 "rechargeMax": 2,
 "logoUrl": "http://47.98.65.112:8788http://47.98.65.112:8788http://47.98.65.112:8788/coinIcon/2018/9/19/bda52c6e2f5a459ebb0eb0005062b6a0.png",
 "coinPrecision": 8,
 "coinKind": "BTC"
 },
 {
 "coinCode": "BCH",
 "coinFullName": "Bitcoin Cash",
 "coinName": "比特现金\t",
 "isdraw": 1,
 "isrecharge": 1,
 "drawMin": 0.0001,
 "drawMax": 1000,
 "rechargeMin": 1,
 "rechargeMax": 2,
 "logoUrl": "http://47.98.65.112:8788/coinIcon/2018/9/19/5eadb69b60264d69847a7a6438d4e06a.png",
 "coinPrecision": 8,
 "coinKind": "BCH"
 },
 {
 "coinCode": "LTC",
 "coinFullName": "Litecoin",
 "coinName": "莱特币",
 "isdraw": 1,
 "isrecharge": 1,
 "drawMin": 0.01,
 "drawMax": 1000,
 "rechargeMin": 1,
 "rechargeMax": 2,
 "logoUrl": "http://47.98.65.112:8788/coinIcon/2018/9/20/7455578ed8ed439d8e58d2d4c6f498c8.png",
 "coinPrecision": 8,
 "coinKind": "LTC"
 },
 {
 "coinCode": "ETH",
 "coinFullName": "Ethereum",
 "coinName": "以太坊",
 "isdraw": 1,
 "isrecharge": 1,
 "drawMin": 1e-8,
 "drawMax": 299.00000001,
 "rechargeMin": 1,
 "rechargeMax": 2,
 "logoUrl": "http://47.98.65.112:8788/coinIcon/2018/9/19/cbdb9baedfe548648aa40d2f2a7e71be.png",
 "coinPrecision": 8,
 "coinKind": "ETH"
 },
 {
 "coinCode": "USDT",
 "coinFullName": "Tether USD",
 "coinName": "泰达币",
 "isdraw": 1,
 "isrecharge": 1,
 "drawMin": 1.00000001,
 "drawMax": 100,
 "rechargeMin": 1,
 "rechargeMax": 2,
 "logoUrl": "http://47.98.65.112:8788/coinIcon/2018/9/19/76dadaa7aaf24c45aabf48547f5ae1d2.png",
 "coinPrecision": 4,
 "coinKind": "USDT"
 },
 {
 "coinCode": "SZ",
 "coinFullName": "SZ",
 "coinName": "数字币",
 "isdraw": 1,
 "isrecharge": 1,
 "drawMin": 0.000001,
 "drawMax": 40000000,
 "rechargeMin": 1,
 "rechargeMax": 2,
 "logoUrl": "http://47.98.65.112:8788/coinIcon/2018/9/18/f8d22a5ae6af4afcb709b63a058d4c2f.png",
 "coinPrecision": 2,
 "coinKind": "ETH"
 },
 {
 "coinCode": "BTCT",
 "coinFullName": "BitCoinTEST",
 "coinName": "比特币",
 "isdraw": 1,
 "isrecharge": 1,
 "drawMin": 0.0005,
 "drawMax": 100,
 "rechargeMin": 1,
 "rechargeMax": 2,
 "logoUrl": "http://47.98.65.112:8788/coinIcon/2018/9/8/bec1d61f909e44d7b6515a4c0dfd4267.png",
 "coinPrecision": 8,
 "coinKind": "BTC"
 },
 {
 "coinCode": "ETHT",
 "coinFullName": "EthereumTEST",
 "coinName": "以太坊",
 "isdraw": 1,
 "isrecharge": 1,
 "drawMin": 0.05,
 "drawMax": 2000,
 "rechargeMin": 1,
 "rechargeMax": 2,
 "logoUrl": "http://47.98.65.112:8788/coinIcon/2018/9/8/a5124ce060e54dc982dd482c60c29890.png",
 "coinPrecision": 7,
 "coinKind": "ETH"
 },
 {
 "coinCode": "USDTT",
 "coinFullName": "Tether USDTEST",
 "coinName": "泰达币",
 "isdraw": 1,
 "isrecharge": 1,
 "drawMin": 10,
 "drawMax": 600000,
 "rechargeMin": 1,
 "rechargeMax": 2,
 "logoUrl": "http://47.98.65.112:8788http://47.98.65.112:8788http://47.98.65.112:8788/coinIcon/2018/9/8/0430b9a7cbc04b9cb94a5396741c8313.png",
 "coinPrecision": 4,
 "coinKind": "USDT"
 },
 {
 "coinCode": "SZT",
 "coinFullName": "SZTEST",
 "coinName": "数字币",
 "isdraw": 1,
 "isrecharge": 1,
 "drawMin": 1000,
 "drawMax": 40000000,
 "rechargeMin": 1,
 "rechargeMax": 2,
 "logoUrl": "http://47.98.65.112:8788/coinIcon/2018/9/8/ae60231f9c80455499d3fb8db8622466.png",
 "coinPrecision": 2,
 "coinKind": "ETH"
 },
 {
 "coinCode": "TEST",
 "coinFullName": "测试币",
 "coinName": "测试币",
 "isdraw": 1,
 "isrecharge": 1,
 "drawMin": 1000,
 "drawMax": 40000000,
 "rechargeMin": 2,
 "rechargeMax": 2,
 "logoUrl": "http://47.98.65.112:8788/coinIcon/2018/9/8/b956580e91704b25bb17b1467159a2b3.png",
 "coinPrecision": 2,
 "coinKind": "ETH"
 },
 {
 "coinCode": "TEST1",
 "coinFullName": "TEST1",
 "coinName": "TEST1",
 "isdraw": 1,
 "isrecharge": 1,
 "drawMin": 0.0001,
 "drawMax": 1000,
 "rechargeMin": 1,
 "rechargeMax": 2,
 "logoUrl": "http://47.98.65.112:8788http://47.98.65.112:8788http://47.98.65.112:8788http://47.98.65.112:8788/coinIcon/2018/9/8/1d729fab2c514e2086924b6a00ce7d71.png",
 "coinPrecision": 5,
 "coinKind": "ETH"
 },
 {
 "coinCode": "HQ",
 "coinFullName": "hangqing",
 "coinName": "行情",
 "isdraw": 1,
 "isrecharge": 1,
 "drawMin": 1,
 "drawMax": 10,
 "rechargeMin": 2,
 "rechargeMax": 2,
 "logoUrl": "http://47.98.65.112:8788/coinIcon/2018/9/8/e678cc84039a48108f5d2ee7feaf84de.png",
 "coinPrecision": 1,
 "coinKind": "ETH"
 }
 ]
 }
 */
