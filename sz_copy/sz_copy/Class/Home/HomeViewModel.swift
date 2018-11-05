//
//  HomeViewModel.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/19.
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
class HomeViewModel: BaseViewModel {
    
    var bannerModels: [BannerModel]?
    var bannerPicPaths = Variable<[String]>([])
    
    var announcementModels: [AnnouncementModel]?
    var announcementTitles = Variable<[String]>([])
    
    var todayDividendTotalModel = Variable<DividendTotalModel?>(nil)
    var yesterdayDividendTotalModel = Variable<DividendTotalModel?>(nil)
    
    var exchangeTotalModel = Variable<ExchangeTotalModel?>(nil)
    
    
    override init() {
        super.init(vcName: HomeViewController.wholeClassName)
    }
    
    override func initialize() {
        requirdBanner()
        requirdAnnouncementList()
        requirdTodayDividendTotal()
        requirdYesterdayDividendTotal()
        requirdGetExchangeTotal()
    }
    
    //点击banner进入web页面
    public func bannerPush(index: Int){
        let viewModel = WebViewModel()
        viewModel.param(bannerModels![index]).push()
    }
    //点击公告进入web页面
    public func noticePush(index: Int){
        let viewModel = WebViewModel()
        viewModel.param(announcementModels![index]).push()
    }
    

    ///  订阅法币汇率，btc汇率，行情服务
    func subscriptSocketServer() {
        APPTransactionPair.default.subscriptAllTickServer()
            APPTransactionPair.default.subscriptExTick()
            APPTransactionPair.default.subscriptExTicBTC()
    }
    
    ///  取消法币汇率，btc汇率，行情服务
    func cancelSocketServer() {
       APPTransactionPair.default.cancelSubScriptExTick()
        APPTransactionPair.default.cancelSubScriptExTicBTC()
        APPTransactionPair.default.cancelSubScriptTickServer()
    }
    //请求banner
    private func requirdBanner() {
        self.model.request(.Banner, BannerRequestModel.self).subscribe {[weak self] event -> Void in
            switch event {
            case .success(let repos):
                self?.bannerModels = repos.data
                self?.bannerModels?.forEach{ model in
                    if model.name.uppercased().hasSuffix("EN")
                    && UserInfo.default.isEnglish {
                        self?.bannerPicPaths.value.append(model.picPath)
                    }
                    
                    if model.name.uppercased().hasSuffix("EN") == false
                        && UserInfo.default.isEnglish == false {
                        self?.bannerPicPaths.value.append(model.picPath)
                    }
                        
                    
                }
            case .error(let error):
                print(error)
            }
            }.disposed(by: disposeBag)
    }
    
    //请求公告内容
    private func requirdAnnouncementList() {
        self.model.request(.AnnouncementList, AnnouncementListRequestModel.self).subscribe {[weak self] event -> Void in
            switch event {
            case .success(let repos):
                self?.announcementModels = repos.data
                self?.announcementModels?.forEach{ model in
                    self?.announcementTitles.value.append(model.title)
                }
            case .error(let error):
                print(error)
            }
            }.disposed(by: disposeBag)
    }
    
    //获取今日分配收益
    private func requirdTodayDividendTotal() {
        self.model.request(.TodayDividendTotal, DividendTotalRequestModel.self).subscribe {[weak self] event -> Void in
            switch event {
            case .success(let repos):
                self?.todayDividendTotalModel.value = repos.data
            case .error(let error):
                print(error)
            }
            }.disposed(by: disposeBag)
    }
    
    //获取昨日分配收益
    private func requirdYesterdayDividendTotal() {
        self.model.request(.YesterdayDividendTotal, DividendTotalRequestModel.self).subscribe {[weak self] event -> Void in
            switch event {
            case .success(let repos):
                self?.yesterdayDividendTotalModel.value = repos.data
                
            case .error(let error):
                print(error)
            }
            }.disposed(by: disposeBag)
    }
    
    //获取挖矿汇总信息
    private func requirdGetExchangeTotal() {
        self.model.request(.ExchangeTotal, ExchangeTotalRequestModel.self).subscribe {[weak self] event -> Void in
            switch event {
            case .success(let repos):
                self?.exchangeTotalModel.value = repos.data
            case .error(let error):
                print(error)
            }
            }.disposed(by: disposeBag)
    }
    
    
    
    private func requireAllTradeInfo() {
//        self.model.request(.AllTradeInfo, DataModel<[[String: [[String: Any]]]]>.self).subscribe { event -> Void in
//            switch event {
//            case .success(let repos):
//                self.repos = repos
//
//                if let data = self.repos?.data {
//                    data.forEach{ (dic) in
//                        print(dic)
//                        let key = dic.keys.first!
//                        self.sourceCoins.append(key)
//                        self.coinPairs[key] = [CoinPairModel]()
//                        self.coinPairNames[key] = [String]()
//                        guard let data = dic.values.first?.first else {
//                            return
//                        }
//                        let coinPairModel =  Mapper<CoinPairModel>().map(JSON: (data))
//                        self.coinPairModel.append(coinPairModel!)
//                        self.coinPairs[key]?.append(coinPairModel!)
//                        self.coinPairNames[key]?.append(coinPairModel!.tradeCode)
//                    }
//                }
//            case .error(let error):
//                print(error)
//            }
//            }.disposed(by: disposeBag)
    }
}


