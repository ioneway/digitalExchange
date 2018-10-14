//
//  UIColor+ext.swift
//  Exchange
//
//  Created by rui on 2018/4/18.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit
extension UIColor {
    
    public convenience init(hex: Int, alpha: CGFloat) {
        self.init(red: (CGFloat((hex & 0xff0000) >> 16) / 255.0), green: CGFloat((hex & 0xff00) >> 8) / 255.0, blue: CGFloat(hex & 0xff)/255.0, alpha: alpha)
    }
    
    public convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    public convenience init(hexStr: String, alpha: CGFloat) {
        var hex = hexStr
        if hex.hasPrefix("#") {
            let startIndex: String.Index = hex.startIndex
            let endIndex: String.Index = hex.index(startIndex, offsetBy: 1)
            hex.removeSubrange(startIndex..<endIndex)
        }
        if hex.count != 6 {
             self.init(white: 0, alpha: alpha)
            return
        }
        let scan = Scanner(string: hex)
        var hexInt : UInt32 = 0
        scan.scanHexInt32(&hexInt)
        self.init(hex: Int(hexInt), alpha: alpha)
    }
    
    public convenience init(hexStr: String) {
        self.init(hexStr: hexStr, alpha: 1.0)
    }
    func rgb(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    ///不需要除以255.0
    public convenience init(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}
