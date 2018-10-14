//
//  String+Tools.swift
//  tools_swift
//
//  Created by 王伟 on 2018/8/11.
//  Copyright © 2018年 王伟. All rights reserved.
// String  工具

import Foundation

extension String {
    func subString(start: Int, length: Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy: start)
        let en = self.index(st, offsetBy: len)
        
        return String(self[st ..< en])
    }
    
    //国际化
    var local: String {
        return NSLocalizedString(self, tableName: "Localizable", comment: "")
    }
    
    //去除科学计数
    var noEnotation : String {
        let numFormatter = NumberFormatter()
        numFormatter.maximumFractionDigits = 800
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.alwaysShowsDecimalSeparator = false
        let str = numFormatter.string(from: self.number)
        return str ?? "0"
    }
    
    //url
    var url: URL? {
        return URL.init(string: self)
    }
    
    //是否可以转换为数字
    var isNumber: Bool {
        if Double(self) == nil {
            return false
        }else {
            return true
        }
    }
    
    //删除小数点后小数多余的0
    func removeMoreZero() -> String {
        var outNumber = self
        var i = 1
        if self.contains("."){
            while i < self.count{
                if outNumber.hasSuffix("0"){
                    outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
                    i = i + 1
                }else{
                    break
                }
            }
            if outNumber.hasSuffix("."){
                outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
            }
            return outNumber
        }
        return self
    }
    
    //转换为格式化数字字符串，输入必须为数字字符串
    func toNumber(_ numberStyle: NumberFormatter.Style) -> String {
        let format = NumberFormatter()
        if self.isNumber{
            let num = format.number(from: self)
            return format.string(from: num!)!
        }
        fatalError("字符串无法转换为数字")
    }
    
    //提取字符串中的数字
    func extractNum() -> String {
        let scanner = Scanner(string: self)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
        var number :Int = 0
        scanner.scanInt(&number)
        return String(number)
    }
    
    //url转码
    func urlEncode() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    //转换为km
    var km: String {
        let m = self.decimal / 1000000.0.decimal
        if m > 1.0.decimal {
            return m.roundStr_down(2,suffixZero: true) + "M"
        }
        let k = self.decimal / 1000.0.decimal
        if k > 1.0.decimal {
            return k.roundStr_down(2, suffixZero: true) + "K"
        }
        return self.decimal.roundStr_down(2,  suffixZero: true)
    }
    
    //个别地方使用： 金额大于1或者等于0时显示2位小数，小于1时显示4位
    var szMoneyFormat: String {
        if self.decimal >= 1 || self.decimal == 0{
            return self.decimal.roundStr_plain(2, suffixZero: true)
        } else {
            return self.decimal.roundStr_plain(4, suffixZero: true)
        }
    }
}
