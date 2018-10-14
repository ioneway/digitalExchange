//
//  UIView+event.swift
//  Exchange
//
//  Created by 王伟 on 2018/8/16.
//  Copyright © 2018年 common. All rights reserved.
//


import Foundation
import UIKit

extension UIView {
    
    public func addOnClickListener(target: AnyObject, action: Selector) {
        let tapGes = UITapGestureRecognizer(target: target, action: action);
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGes);
    }
}
