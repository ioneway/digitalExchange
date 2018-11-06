//
//  UIColor+Asset.swift
//  tools_swift
//
//  Created by 王伟 on 2018/8/11.
//  Copyright © 2018年 王伟. All rights reserved.
//

import Foundation
import UIKit
import NightNight

typealias ColorAsset = UIColor.Asset

extension MixedColor {
    
    public convenience init(day: String, night: String) {
        let normalColor = UIColor.init(hexStr: day)
        let nightColor = UIColor.init(hexStr: night)
        self.init(normal: normalColor, night: nightColor)
    }
}

public class ThemeColor {
    public static let `default` = ThemeColor()
    public var night = [String: String]()
    public var day = [String: String]()
    
    init() {
        loadThemeInfo()
    }
    
    private func loadThemeInfo() {
        let nightFile = "night.json"
        let dayFile = "day.json"
        
        guard let nightPath = Bundle.main.path(forResource: nightFile, ofType: nil) else {return}
        guard let dayPath = Bundle.main.path(forResource: dayFile, ofType: nil) else {return}
        
        let nightUrl = URL(fileURLWithPath: nightPath)
        let dayUrl = URL(fileURLWithPath: dayPath)
        
        guard let nightdata = try? Data(contentsOf: nightUrl) else { return  }
        guard let nightDict = try? JSONSerialization.jsonObject(with: nightdata, options: .mutableContainers) else { return }
        night = nightDict as! [String:String]
        
        guard let daydata = try? Data(contentsOf: dayUrl) else { return  }
        guard let dayDict = try? JSONSerialization.jsonObject(with: daydata, options: .mutableContainers) else { return }
        day = dayDict as! [String:String]
    }
}


extension UIColor {
    public enum Asset: String {
        
        enum BackGround: String {
            case Level1 = "BackGround_Level1"
            case Level2 = "BackGround_Level2"
            case Level3 = "BackGround_Level3"
            case Level4 = "BackGround_Level4"  //Tabbar颜色
            case Level5 = "BackGround_Level5"  //交易首页导航栏
            
            
            var color : UIColor {
                return UIColor(hexStr: self.rawValue)
            }
            var mixColor : MixedColor {
                return MixedColor.init(day: ThemeColor.default.day[self.rawValue] ?? "#000000", night: ThemeColor.default.day[self.rawValue] ?? "#000000")
            }
        }
        
        enum Text: String {
            case Level1 = "Text_Level1"
            case Level2 = "Text_Level2"
            case Level3 = "Text_Level3"
            case Level4 = "Text_Level4"
            case Level5 = "Text_Level5"
            case Level6 = "Text_Level6"
            
            var color : UIColor {
                return UIColor(hexStr: self.rawValue)
            }
            var mixColor : MixedColor {
                return MixedColor.init(day: ThemeColor.default.day[self.rawValue] ?? "#000000", night: ThemeColor.default.day[self.rawValue] ?? "#000000")
            }
        }
        
        enum Block: String {
            case Main = "Block_Main"
            case Drop = "Block_Drop"
            case Increase = "Block_Increase"
            case Seperate = "Block_Seperate"
            case Red = "Block_Red"
            case node = "Block_node"
            
            var color : UIColor {
                return UIColor(hexStr: self.rawValue)
            }
            var mixColor : MixedColor {
                return MixedColor.init(day: ThemeColor.default.day[self.rawValue] ?? "#000000", night: ThemeColor.default.day[self.rawValue] ?? "#000000")
            }
        }
        
        case White = "#FFFFFF"
        
        var color : UIColor {
            return UIColor(hexStr: self.rawValue)
        }
        var mixColor : MixedColor {
            return MixedColor.init(day: ThemeColor.default.day[self.rawValue] ?? "#000000", night: ThemeColor.default.day[self.rawValue] ?? "#000000")
        }
    }
}


/****使用*****/
/*
 *  func a()
    {
        let color = ColorAsset(hexStr: self)
    }
 */
