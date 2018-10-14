//
//  UIColor+Asset.swift
//  tools_swift
//
//  Created by 王伟 on 2018/8/11.
//  Copyright © 2018年 王伟. All rights reserved.
//

import Foundation
import UIKit

typealias ColorAsset = UIColor.Asset

extension UIColor {
    public enum Asset: String {
        public typealias RawValue = String
        
        enum BackGround: String {
            case Level1 = "#2F364D"
            case Level2 = "#232939"
            case Level3 = "#191D29"
            case Level4 = "#121621"  //Tabbar颜色
            
            var color : UIColor {
                return UIColor(hexStr: self.rawValue)
            }
        }
        
        enum Text: String {
            case Level1 = "#CDD5E2"
            case Level2 = "#93A2B8"
            case Level3 = "#667791"
            case Level4 = "#4B5A71"
            
            case Level5 = "#AFB9C8"
            
            var color : UIColor {
                return UIColor(hexStr: self.rawValue)
            }
        }
        
        enum Block: String {
            case Main = "#AB2F2F"
            case Drop = "#E83430"
            case Increase = "#109053"
            case Seperate = "#485E7E"
            case Red = "#B82A2A"
            var color : UIColor {
                return UIColor(hexStr: self.rawValue)
            }
        }
        
        case White = "#FFFFFF"
        
        var color : UIColor {
            return UIColor(hexStr: self.rawValue)
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
