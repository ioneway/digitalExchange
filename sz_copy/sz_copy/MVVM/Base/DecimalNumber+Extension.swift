//
//  DecimalNumber+Extension.swift
//  Exchange
//
//  Created by 王伟 on 2018/9/6.
//  Copyright © 2018年 common. All rights reserved.
//

import Foundation


public func + (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber{
    let result = left.adding(right)
    return result
}

public func - (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber{
    let result = left.subtracting(right)
    return result
}

public func * (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber{
    let result = left.multiplying(by: right)
    return result
}

public func / (left: NSDecimalNumber, right: NSDecimalNumber) -> NSDecimalNumber{
    
    let roundingBehavior = NSDecimalNumberHandler.init(
        roundingMode: .down,
        scale: Int16(Int16.max),
        raiseOnExactness: false,
        raiseOnOverflow: false,
        raiseOnUnderflow: false,
        raiseOnDivideByZero: false)
    
    let result = left.dividing(by: right, withBehavior: roundingBehavior)
    return result
}


//public enum ComparisonResult : Int {
//    case orderedAscending 左操作数小于右操作数
//    case orderedSame 左操作数等于右操作数
//    case orderedDescending。左操作大于右操作数
//}

public func > (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool{
    let result = left.compare(right)
    if result == .orderedDescending {
        return true
    }else {
        return false
    }
}

public func == (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool{
    let result = left.compare(right)
    if result == .orderedSame {
        return true
    }else {
        return false
    }
}

public func < (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool{
    let result = left.compare(right)
    if result == .orderedAscending {
        return true
    }else {
        return false
    }
}

public func <= (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool{
    return !(left > right)
}

public func >= (left: NSDecimalNumber, right: NSDecimalNumber) -> Bool{
    return !(left < right)
}


extension NSDecimalNumber {
    func round(scale: Int , roundingMode: NSDecimalNumber.RoundingMode) -> NSDecimalNumber {
        
        let roundingBehavior = NSDecimalNumberHandler.init(
            roundingMode: roundingMode,
            scale: Int16(scale),
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false)
        let result = self.rounding(accordingToBehavior: roundingBehavior)
        return result == NSDecimalNumber.notANumber ? NSDecimalNumber.init(value: 0): result
    }
    
    
    /// 保留位数，返回字符串
    ///
    /// - Parameters:
    ///   - scale: 保留位数
    ///   - roundingMode: 模式 plain：四舍五入，up: 只入不舍， down：只舍不入， bankers：
    ///   - suffixZero: 位数不足时，是否补0，true：补0，false：不补0.  默认为false
    /// - Returns: 返回处理后的字符串
    func roundStr(scale: Int , roundingMode: NSDecimalNumber.RoundingMode, suffixZero: Bool = false) -> String {
        
        let result = self.round(scale: scale, roundingMode: roundingMode)
        
        let digit = scale
        
        if suffixZero == false {
            return result.stringValue
        }else {
            var formatterString : String = "0."
            let count : Int = (digit < 0 ? 0 : digit)
            for _ in 0 ..< count {
                formatterString.append("0")
            }
            let formatter : NumberFormatter = NumberFormatter()
            formatter.positiveFormat = formatterString
            return formatter.string(from: result) != nil ? formatter.string(from: result)! : "0"
        }
    }
    
    func roundStr_up(_ scale: Int, suffixZero: Bool = false) -> String {
        return self.roundStr(scale: scale, roundingMode: .up, suffixZero: suffixZero)
    }
    
    
    func roundStr_down(_ scale: Int, suffixZero: Bool = false) -> String {
        return self.roundStr(scale: scale, roundingMode: .down, suffixZero: suffixZero)
    }
    
    func roundStr_plain(_ scale: Int, suffixZero: Bool = false) -> String {
        return self.roundStr(scale: scale, roundingMode: .plain, suffixZero: suffixZero)
    }
    
    func roundStr_bankers(_ scale: Int, suffixZero: Bool = false) -> String {
        return self.roundStr(scale: scale, roundingMode: .bankers, suffixZero: suffixZero)
    }
}


extension Int: DeecimalNumberProtocol{
    var decimal: NSDecimalNumber {
        return  NSDecimalNumber.init(value: self)
    }
    var number: NSNumber {
        return NSNumber.init(value: self)
    }
    var string: String {
        return "\(self)"
    }
}

extension Double: DeecimalNumberProtocol {
    var decimal: NSDecimalNumber {
        return NSDecimalNumber.init(value: self)
    }
    var number: NSNumber {
        return NSNumber.init(value: self)
    }
    var string: String {
        return "\(self)"
    }
}

extension NSNumber {
    var decimal: NSDecimalNumber {
        return NSDecimalNumber.init(string: self.stringValue)
    }
}

protocol DeecimalNumberProtocol {
    var decimal: NSDecimalNumber {get}
    var number: NSNumber {get}
    var string: String {get}
}

extension Float: DeecimalNumberProtocol {
    var decimal: NSDecimalNumber {
        return NSDecimalNumber.init(value: self)
    }
    var number: NSNumber {
        return NSNumber.init(value: self)
    }
    var string: String {
        return "\(self)"
    }
}

extension String: DeecimalNumberProtocol  {
    var decimal: NSDecimalNumber {
        return NSDecimalNumber.init(string: self)
    }
    var number: NSNumber {
        return NSNumber.init(value: (Double(self) ?? 0))
    }
    var string: String {
        return self
    }
}

extension NSNumber: DeecimalNumberProtocol  {
    var number: NSNumber {
        return self
    }
    //去除科学计数法
    var string : String {
        let numFormatter = NumberFormatter()
        numFormatter.maximumFractionDigits = 8
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.alwaysShowsDecimalSeparator = false
        let str = numFormatter.string(from: self)
        return str ?? "0"
    }
}

extension NSNumber {
    
    //去除科学计数法
    var numString : String? {
        let numFormatter = NumberFormatter()
        numFormatter.maximumFractionDigits = 8
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.alwaysShowsDecimalSeparator = false
        let str = numFormatter.string(from: self)
        return str
    }
}

