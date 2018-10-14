//
//  LZDoubleTransform.swift
//  Exchange
//
//  Created by 王伟 on 2018/9/6.
//  Copyright © 2018年 common. All rights reserved.
//

import ObjectMapper

class LZDecimalTransform : TransformType {
    
    typealias Object = NSDecimalNumber
    typealias JSON = Double
    
    public init() {}
    
    func transformToJSON(_ value: NSDecimalNumber?) -> Double? {
        if let value = value{
            return value.doubleValue
        }else {
            return 0.00
        }
    }
    
    open func transformFromJSON(_ value: Any?) -> NSDecimalNumber? {
        if let _ = value as? Double  {
            return NSDecimalNumber.init(string: (value as? Double ?? 0).number.numString)
        }else {
            return NSDecimalNumber.init(string: "\(value ?? "0.00")")
        }
    }
}
