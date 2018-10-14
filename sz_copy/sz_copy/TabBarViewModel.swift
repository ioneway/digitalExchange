//
//  TabBarViewModel.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/17.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit

class TabBarViewModel: BaseViewModel {
    
    let homeViewModel = HomeViewModel()
    let marketViewModel = MarketViewModel()
    let exchangeViewModel = ExchangeViewModel()
    let miningViewModel = MiningViewModel()
    let mineViewModel = MineViewModel()
    
    override init() {
        super.init(vcName: ViewController.wholeClassName)
    }
}
