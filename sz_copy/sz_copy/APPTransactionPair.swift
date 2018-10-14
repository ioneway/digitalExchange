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
    
    var exTickDatas: ExTickModels?  //数字货币兑法币的汇率
    var exTickBTCDatas: ExTickBTCModels?  //数字币兑BTC的汇率
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
    
    var sourceCoinsVariable = Variable<[String]>([String]())
    var coinMarketDicVariable = Variable<[String: [TickModel]]>([String: [TickModel]]())
    
    private let _disposeBag = DisposeBag()
    
    @discardableResult
    override init() {
        super.init()
        SocketManager.shared.delegate = self
        
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
                try! realm.write {
                    realm.add(self.coinDetailModels!)
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
    
    
    func subscriptTickServer(coinName: String ) {
        let pairs = self.coinPairNames[coinName]
        var symbols = [String]()
        for (_, pair) in (pairs?.enumerated())! {
            let infor = pair.replacingOccurrences(of: "/", with: "_")
            if infor.count != 0 {
                symbols.append(infor)
            }
        }
        var server = ServerTick()
        server.symbols = symbols
        SocketManager.shared.subscribe(server: server)  ////行情
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
        self.exTickDatas = Mapper<ExTickModels>().map(JSON: data)
    }
    
    //    /// 获取数字币兑BTC的汇率
    func socket(didReadExTicBTC data: [String : Any]) {
        self.exTickBTCDatas = Mapper<ExTickBTCModels>().map(JSON: data)
    }
    
    /// 数字货币行情
    func socket(didReadTick data: [String : Any]) {
        let tickResponse = Mapper<TickRequestModel>().map(JSON: data)
        let mainCoin = tickResponse?.datas?[0].coinPairLastName
        if let mainCoin = mainCoin {
            self.coinMarketDicVariable.value[mainCoin] = tickResponse?.datas
        }
    }
    
}

