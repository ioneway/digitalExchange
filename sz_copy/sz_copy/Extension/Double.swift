//
//  Double.swift
//  Exchange
//
//  Created by 孟祥群 on 2018/5/17.
//  Copyright © 2018年 common. All rights reserved.
//

import Foundation

extension Double {
    
    /// Rounds the double to decimal places value
    
    func roundTo(places:Int) -> Double {
        
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded() / divisor
        
    }
    
}
