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


enum ExchangeDirection: String {
    case buy  = "买入"  //买入
    case sell = "卖出"  //卖出
}

enum PriceType: String  {
    case limit = "限价"   //限价
    case market = "市价"         //市价
}

enum TradeType {
    case limitBuy     //买入
    case limitSell    //卖出
    case marketBuy     //买入
    case marketSell    //卖出
}


/*
 targetCoin/SourceCoin
 */
class ExchangeViewModel: BaseViewModel {
    
    /// 交易方向
    var exchangeDirectionVariable: Variable<ExchangeDirection> = Variable<ExchangeDirection>(.buy)
    /// 价格类型： 市价，限价
    var priceTypeVariable: Variable<PriceType> = Variable<PriceType>(.limit)
    
    /// 交易类型, 计算属性
    var tradeType: TradeType {
        get {
            if exchangeDirectionVariable.value == .buy {
                if priceTypeVariable.value == .limit {
                    return .limitBuy
                }else {
                    return .limitSell
                }
            }else {
                if priceTypeVariable.value == .market {
                    return .marketBuy
                }else {
                    return .marketSell
                }
            }
        }
    }
    
    
    /// 价格输入框的价格，初始值为当前交易价格
    var coinPriceVariable: Variable<String> = Variable<String>("")
    /// 当前价格(法币价格)，输入框内当前币币交易价格和汇率计算得到
    var currencyPriceVariable: Variable<String> = Variable<String>("≈--")
    
    /// 数量框内的显示的数量
    var numberVariable: Variable<String> = Variable<String>("")
    
    /// 可用币数量
    var canUseNumVariable: Variable<String> = Variable<String>("")
    
    /// 交易币种，币种一
    var coinCodeVariable: Variable<String> = Variable<String>("SZ")
    
//    var

    override init() {
        super.init(vcName: ExchangeViewController.wholeClassName)
    }
    
    override func initialize() {
       
    }
}

