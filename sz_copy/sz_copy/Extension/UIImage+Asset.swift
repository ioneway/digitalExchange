//
//  UIImage+Asset.swift
//  TSWeChat
//
//  Created by Hilen on 11/9/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

/*
https://github.com/AliSoftware/SwiftGen 在电脑上安装这个工具，自动生成 Asset 的 image enum 的 Extension
*/




import Foundation
import UIKit
import NightNight

typealias ImgAsset = UIImage.Asset

extension MixedImage {
    public convenience init(asset: String) {
        self.init(normal: UIImage(named: asset)!, night: UIImage(named:asset+"_night")!)
    }
}


extension UIImage {
    enum Asset : String {
        case Tab_home = "tab_home_normal_night"
        case Tab_home_selected = "tab_home_selected_night"
        
        case Tab_market = "tab_market_normal_night"
        case Tab_market_selected = "tab_market_selected_night"
        
        case Tab_exchange = "tab_exchange_normal_night"
        case Tab_exchange_selected = "tab_exchange_selected_night"
        
        case Tab_mining = "tab_mining_normal_night"
        case Tab_mining_selected = "tab_mining_selected_night"
        
        case Tab_mine = "tab_mine_normal_night"
        case Tab_mine_selected = "tab_mine_selected_night"
        
        case notice = "notice"
        case pageControl_selected = "pageControl_selected"
        case pageControl = "pageControl"
        case coinDefault = "coin_default"
        
        case minus = "minus"
        case plus = "plus"
        case downBtn = "downBtn"
        
        case portrait = "portrait"
        case arrow_right = "arrow_right"
        case dollar = "dollar"
        case location = "location"
        case help = "Help"
        case security = "Security"
        case gift = "gift"
        case digitalNode = "digitalNode"
        case arrow_right_big = "arrow_right_big"
        case setting = "setting"
        case cornerStone = "CornerSotone"
        
        var image: UIImage {
            return UIImage(asset: self)
        }
        
        public var mixImg: MixedImage {
            return MixedImage.init(asset: self.rawValue)
        }
    }
    
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
    
    
}

/****使用*****/
/*
 *  func a()
    {
        let img =  ImgAsset.Tabbar_me.image
    }
 */



