//
//  ExTickModel.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/25.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import SwiftyUserDefaults


extension DefaultsKeys {
    static let exTickModels = DefaultsKey<ExTickModels?>("exTickModels")
}

final class ExTickModel:  Mappable, Codable, DefaultsSerializable {
    
    private(set) var money: String?
    var symbols: [String: Double]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map)
    {
        money <- map["money"]
        symbols <- map["symbols"]
    }
}

final class ExTickModels:  Mappable, Codable, DefaultsSerializable {
    
    private(set) var cmd: String?
    private(set) var data: [ExTickModel]?
    private(set) var code: Int = -1
    
    required init?(map: Map) {
        NotificationCenter.default.addObserver(self, selector: #selector(write), name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    public init() {
       let models = Defaults[.exTickModels]
        cmd = models?.cmd
        data = models?.data
        code = (models?.code)!
    }
    
    func mapping(map: Map)
    {
        cmd <- map["cmd"]
        data <- map["data"]
        code <- map["code"]
    }
    
    subscript(coin: String) -> NSDecimalNumber?
    {
        get {
            //当“SZ”时，后台数据可能没有返回法币汇率，所以先转换为BTC汇率然后乘BTC法币汇率
            var rate = 1.0.decimal
            if coin.lowercased() == "SZ".lowercased() && currentExTicModel()?.symbols?[coin] == nil{
                if APPTransactionPair.default.exTickBTCDatas != nil {
                    if let szTick = APPTransactionPair.default.exTickBTCDatas?["SZ"]{
                        let btcRate = self["BTC"]
                        rate = szTick * btcRate!
                    }
                }
                return rate
            }else {
                let result = currentExTicModel()?.symbols?[coin]
                return "\(result ?? 0)".decimal
            }
        }
    }
    
    @objc private func write() { //写入数据
        Defaults[.exTickModels] = self
    }
    
    /// 根据当前法币币种，获取对应的ExTickModel
    private func currentExTicModel() -> ExTickModel?
    {
        guard let data = data else {
            return nil
        }
        for model in data {
            if model.money?.lowercased() == UserInfo.default.currency.lowercased() {
                return model
            }
        }
        return nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


