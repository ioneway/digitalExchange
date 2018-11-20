//
//  HomeViewController.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/19.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit

class MarketViewController: BaseViewController<MarketViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


struct MarketMenuOptions: PagingMenuControllerCustomizable {
    static var marketVM_0: MarketTableViewModel =  {
        let temp = MarketTableViewModel()
        temp.coinName = APPTransactionPair.default.sourceCoins[0]
        return temp
    }()
    static var marketVM_1: MarketTableViewModel =  {
        let temp = MarketTableViewModel()
        temp.coinName = APPTransactionPair.default.sourceCoins[1]
        return temp
    }()
    static var marketVM_2: MarketTableViewModel =  {
        let temp = MarketTableViewModel()
        temp.coinName = APPTransactionPair.default.sourceCoins[2]
        return temp
    }()
    
    public var marketVC_0 = Router.viewController(marketVM_0) as! MarketTableViewController
    public var marketVC_1 = Router.viewController(marketVM_1) as! MarketTableViewController
    public var marketVC_2 = Router.viewController(marketVM_2) as! MarketTableViewController
    
    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: [marketVC_0, marketVC_1, marketVC_2])
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var height:CGFloat {
            return kHomeViewPagingBarHeight
        }
        var backgroundColor = ColorAsset.BackGround.Level3.color
        var selectedBackgroundColor = ColorAsset.BackGround.Level3.color
        var focusMode: MenuFocusMode {
            let color = ColorAsset.Block.Red.color
            return .underline(height: 4, color: color, horizontalPadding: 20, verticalPadding: 0)
        }
        var menuPosition: MenuPosition {
            return .top
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem_0(), MenuItem_1(), MenuItem_2()]
        }
    }
    
    static let color = ColorAsset.Text.Level3.color
    static let selectedColor = ColorAsset.Block.Red.color
    static let font = FontAsset.PingFangSC_Regular.size(.Level15)
    static let selectedFont = FontAsset.PingFangSC_Semibold.size(.Level15)
    
    struct MenuItem_0: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: APPTransactionPair.default.sourceCoins[0],
                                     color: color,
                                     selectedColor: selectedColor,
                                     font: font,
                                     selectedFont: selectedFont
            )
            return .multilineText(title: title, description: MenuItemText(text: ""))
        }
    }
    
    struct MenuItem_1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: APPTransactionPair.default.sourceCoins[1],
                                     color: color,
                                     selectedColor: selectedColor,
                                     font: font,
                                     selectedFont: selectedFont
            )
            return .multilineText(title: title, description: MenuItemText(text: ""))
        }
    }
    
    struct MenuItem_2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: APPTransactionPair.default.sourceCoins[2],
                                     color: color,
                                     selectedColor: selectedColor,
                                     font: font,
                                     selectedFont: selectedFont
            )
            return .multilineText(title: title, description: MenuItemText(text: ""))
        }
    }
}
