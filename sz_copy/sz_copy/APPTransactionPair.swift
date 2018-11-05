//
//  APPTransactionPair.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/9.
//  Copyright © 2018年 王伟. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import RealmSwift
import RxSwift

class APPTransactionPair: NSObject {
    
    static let `default`: APPTransactionPair = APPTransactionPair()
    
    var exTickDatasVariable = Variable<ExTickModels>(ExTickModels())  //数字货币兑法币的汇率
    var exTickBTCDatasVariable = Variable<ExTickBTCModels>(ExTickBTCModels()) //数字币兑BTC的汇率
    var allCoinDetailModel: AllCoinDetailRequestModel? //数字
    
    var coinDetailModels: [AllCoinDetailModel]? = {
        let realm = try! Realm()
        let coinDetailModels = Array(realm.objects(AllCoinDetailModel.self))
        return coinDetailModels
    } () //获取币币支持的币种
    
    var sourceCoins: [String] {
        get {
            return sourceCoinsVariable.value
        }
        set {
            sourceCoinsVariable.value = newValue
        }
    }
    var coinPairNames = [String: [String]]()
    var coinPairs = [String: [TradeInfoModel]]()
    var coinPairsModels = [TradeInfoModel]()//币种规则
    var coinMarketDic = [String: [TickModel]]()//币种行情
    var coinValueChangeIndexVariable = Variable<[String: Int]>(["":-1])
    
    var sourceCoinsVariable = Variable<[String]>([String]())
    var coinMarketDicVariable = Variable<[String: [TickModel]]>([String: [TickModel]]())
    
    private let _disposeBag = DisposeBag()
    
    @discardableResult
    override init() {
        super.init()
        
        requireAllCoinDetail()
        requireAllTradeInfo()
    }
    
    ///获取币币支持的币种
    func requireAllCoinDetail() {
        
        let realm = try! Realm()
        self.coinDetailModels = Array(realm.objects(AllCoinDetailModel.self))
        
        Model().request(.AllCoinDetail, AllCoinDetailRequestModel.self).subscribe { event -> Void in
            switch event {
            case .success(let repos):
                self.allCoinDetailModel = repos
                self.coinDetailModels = repos.data
                if let models = self.coinDetailModels {
                    try! realm.write {
                        realm.add(models)
                    }
                }
            case .error(let error):
                print(error)
            }
        }.disposed(by: _disposeBag)
    }
    
    ///获取可交易币种
    private func requireAllTradeInfo() {
        Model().request(.AllTradeInfo, AllTradeInfoRequireModel.self).subscribe { event -> Void in
            switch event {
            case .success(let repos):
                
                var sourceCoins = self.sourceCoins
                var coinPairs = self.coinPairs
                var coinPairNames = self.coinPairNames
                var coinPairsModels = self.coinPairsModels
                
                if let data = repos.data {
                    for dic in data {
                        print(dic)
                        let key = dic.keys.first!
                        
                        coinPairs[key] = [TradeInfoModel]()
                        coinPairNames[key] = [String]()
                        
                        if dic.values.first?.count ?? 0 <= 0 {
                            return
                        }
                        for data in dic.values.first! {
                            let coinPairModel =  Mapper<TradeInfoModel>().map(JSON: (data))
                            
                            if coinPairModel?.isSupportCoinTrade ?? false {
                                
                                coinPairNames[key]?.append(coinPairModel!.tradeCode)
                                coinPairsModels.append(coinPairModel!)
                                coinPairs[key]?.append(coinPairModel!)
                            }
                        }
                        sourceCoins.append(key)
                    }
                    
                    self.coinPairs = coinPairs
                    self.coinPairNames = coinPairNames
                    self.coinPairsModels = coinPairsModels
                    self.sourceCoins = sourceCoins
                }
                
                
            case .error(let error):
                print(error)
            }
        }.disposed(by: _disposeBag)
    }
    
    /// 订阅行情， 参数主要币种，币种二
    func subscriptTickServer(coinName: String ) {
        SocketManager.shared.delegate = self
        let pairs = self.coinPairNames[coinName]
        var symbols = [String]()
        for (_, pair) in (pairs?.enumerated())! {
            let infor = pair.replacingOccurrences(of: "/", with: "_")
            if infor.count != 0 {
                symbols.append(infor)
            }
        }
        let server = TickSocket(symbols: symbols)
        SocketManager.shared.subscribe(server: server)
    }
    
    
    /// 订阅行情， 全币对
    func subscriptAllTickServer() {
        SocketManager.shared.delegate = self
        let pairs = coinPairNames.values.reversed()
        var allPair:[String] = []
        pairs.forEach{ item in
            allPair.append(contentsOf: item)
        }
        var symbols = [String]()
        for (_, pair) in allPair.enumerated() {
            let infor = pair.replacingOccurrences(of: "/", with: "_")
            if infor.count != 0 {
                symbols.append(infor)
            }
        }
        let server = TickSocket(symbols: symbols)
        SocketManager.shared.subscribe(server: server)
    }
    
    
    func cancelSubScriptTickServer() {
        let pairs = coinPairNames.values.reversed()
        var allPair:[String] = []
        pairs.forEach{ item in
            allPair.append(contentsOf: item)
        }
        var symbols = [String]()
        for (_, pair) in allPair.enumerated() {
            let infor = pair.replacingOccurrences(of: "/", with: "_")
            if infor.count != 0 {
                symbols.append(infor)
            }
        }
        let server = TickSocket(symbols: symbols)
        SocketManager.shared.cancelSubscribe(server: server)
    }
    
    func cancelSubScriptExTick() {
        SocketManager.shared.cancelSubscribe(server: ServerExTick() as SocketServerable)
    }
    
    func cancelSubScriptExTicBTC() {
        SocketManager.shared.cancelSubscribe(server: ServerExTicBTC() as SocketServerable)
    }
    
    
    //// 订阅法币汇率
    func subscriptExTick() {
        SocketManager.shared.delegate = self
        let server = ServerExTick()
        SocketManager.shared.subscribe(server: server)
    }
    
    //// 订阅BTC汇率
    func subscriptExTicBTC() {
        SocketManager.shared.delegate = self
        let server = ServerExTicBTC()
        SocketManager.shared.subscribe(server: server)
    }
    
    
    func tradeInfoModel(tradeCode: String) -> TradeInfoModel?{
         for model in self.coinPairsModels {
            if tradeCode == model.tradeCode {
                return model
            }
        }
        return nil
    }
}
//
extension APPTransactionPair: SocketManagerDelegate {
    
    /// 获取数字货币兑法币的汇率
    func socket(didReadExTick data: [String : Any]) {
        self.exTickDatasVariable.value = Mapper<ExTickModels>().map(JSON: data) ?? ExTickModels()
    }
    
    /// 获取数字币兑BTC的汇率
    func socket(didReadExTicBTC data: [String : Any]) {
        self.exTickBTCDatasVariable.value = Mapper<ExTickBTCModels>().map(JSON: data) ?? ExTickBTCModels()
    }
    
    /// 数字货币行情
    func socket(didReadTick data: [String : Any]) {
        let tickResponse = Mapper<TickRequestModel>().map(JSON: data)
        let cmd = tickResponse?.cmd
        if cmd == CmdType.tick.rawValue {  //tick
            let mainCoin = tickResponse?.symbol.components(separatedBy: "_").last
            if let mainCoin = mainCoin {
                let models = coinMarketDicVariable.value[mainCoin]
                for model in coinMarketDicVariable.value[mainCoin] ?? [] {
                    if model.symbol == tickResponse?.symbol {
                        model.price = tickResponse?.data?.price ?? ""
                        model.amount = tickResponse?.data?.amount ?? ""
                        model.day_high = tickResponse?.data?.day_high ?? ""
                        model.day_open = tickResponse?.data?.day_open ?? ""
                        model.day_low = tickResponse?.data?.day_low ?? ""
                        model.day_volume = tickResponse?.data?.day_volume ?? ""
                        
                        let index = models?.index {$0.symbol == model.symbol}
                        self.coinValueChangeIndexVariable.value = [mainCoin:index] as! [String : Int]
                    }
                }
            }
        }else { //ticks
            var array = [String: [TickModel]]()
            for model in tickResponse?.datas ?? [] {
                if let mainCoin = model.coinPairLastName {
                    
                    if array.keys.contains(mainCoin) == false{
                        array.updateValue([], forKey: mainCoin)
                    }
                    array[mainCoin]?.append(model)
                }
            }
            if array.count != 0 {
                self.coinMarketDicVariable.value = array
            }
        }
    }
}

