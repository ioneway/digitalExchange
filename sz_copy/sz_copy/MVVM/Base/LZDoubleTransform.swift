//
//  LZDoubleTransform.swift
//  Exchange
//
//  Created by 王伟 on 2018/9/6.
//  Copyright © 2018年 common. All rights reserved.
//

import ObjectMapper

class LZDoubleTransform : TransformType {
    
    typealias Object = String
    typealias JSON = Double
    
    public init() {}
    
    func transformToJSON(_ value: String?) -> Double? {
        if let value = value{
            return Double(value) ?? 0
        }else {
            return 0.00
        }
    }
    
    open func transformFromJSON(_ value: Any?) -> String? {
        if let _ = value as? Double  {
            return "\(value as? Double ?? 0)".noEnotation
        }else {
            return "\(value ?? "0.00")".noEnotation
        }
    }
}
