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
class MarketViewModel: BaseViewModel {
    
    override init() {
        super.init(vcName: MarketViewController.wholeClassName)
    }
    
    override func initialize() {
    
    }
}

