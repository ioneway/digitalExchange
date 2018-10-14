//
//  MarketTableViewModel.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/10.
//  Copyright © 2018 王伟. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa
import Action
import Moya
import Moya_ObjectMapper
import ObjectMapper



class MarketTableViewModel: BaseViewModel {
    
    public var coinName = ""
   
    var dataSourceVariable = Variable<[TickModel]>([TickModel]())
    
    var dataSource: [TickModel] {
        get {
            return dataSourceVariable.value
        }
        set {
            dataSourceVariable.value = newValue
        }
    }
    private let _disposeBag = DisposeBag()
    
    override init() {
        super.init(vcName: MarketTableViewController.wholeClassName)
    }
    
    override func initialize() {
        
    }
    
    func subscriptTickMarket() {
        APPTransactionPair.default.subscriptTickServer(coinName: coinName)
        
        let _ = APPTransactionPair.default.coinMarketDicVariable.asObservable().bind{ result in
            self.dataSource = result[self.coinName] ?? [TickModel]()
        }
    }
    
    
}
