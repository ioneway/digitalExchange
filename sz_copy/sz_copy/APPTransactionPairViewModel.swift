//
//  APPTransactionPairViewModel.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/9.
//  Copyright © 2018年 王伟. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa
import Action
import Moya
import Moya_ObjectMapper
import ObjectMapper

/*
 targetCoin/SourceCoin
 */
class APPTransactionPairViewModel: BaseViewModel {
    
        var coinPairModel = [TradeInfoModel]()
        var sourceCoins = [String]()
        var coinPairNames = [String: [String]]()
        var coinPairs = [String: [TradeInfoModel]]()
        var coinPairsModels = [TradeInfoModel]()
    
    
    override init() {
       super.init()
    }
    
    override func initialize() {
        self.requireAllTradeInfo()
    }
    
    private func requireAllTradeInfo() {
                self.model.request(.AllTradeInfo, AllTradeInfoRequireModel.self).subscribe { event -> Void in
                    switch event {
                    case .success(let repos):
        
                        var sourceCoins = self.sourceCoins
                        var coinPairs = self.coinPairs
                        var coinPairNames = self.coinPairNames
                        var coinPairsModels = self.coinPairsModels
                        
                        if let data = repos.data {
                            data.forEach{ (dic) in
                                print(dic)
                                let key = dic.keys.first!
                                
                                sourceCoins.append(key)
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
                            }
                        }
                        self.sourceCoins = sourceCoins
                        self.coinPairs = coinPairs
                        self.coinPairNames = coinPairNames
                        self.coinPairsModels = coinPairsModels
                        
                    case .error(let error):
                        print(error)
                    }
                }.disposed(by: disposeBag)
    }
}
