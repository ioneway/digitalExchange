//
//  APPContext.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/24.
//  Copyright © 2018年 王伟. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import RealmSwift
import RxSwift

class AppContext: NSObject {
    
    static let `default`: AppContext = AppContext()
    
    var exTickDatas: ExTickModels?  //数字货币兑法币的汇率
    var exTickBTCDatas: ExTickBTCModels?  //数字币兑BTC的汇率
    var allCoinDetailModel: AllCoinDetailRequestModel? //数字
    
    var coinDetailModels: [AllCoinDetailModel]? = {
        let realm = try! Realm()
        let coinDetailModels = Array(realm.objects(AllCoinDetailModel.self))
        return coinDetailModels
    }() //获取币币支持的币种
    
    private let disposeBag = DisposeBag()
    
    @discardableResult
    override init() {
        super.init()
        SocketManager.shared.delegate = self
        requireAllCoinDetail()
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
            }.disposed(by: disposeBag)
    }
}

extension AppContext: SocketManagerDelegate {
    
    /// 获取数字货币兑法币的汇率
    func socket(didReadExTick data: [String : Any]) {
        self.exTickDatas = Mapper<ExTickModels>().map(JSON: data)
    }
    
    /// 获取数字币兑BTC的汇率
    func socket(didReadExTicBTC data: [String : Any]) {
        self.exTickBTCDatas = Mapper<ExTickBTCModels>().map(JSON: data)
    }
    
}
