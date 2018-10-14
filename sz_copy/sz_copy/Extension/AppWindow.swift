//
//  AppWindow.swift
//  Exchange
//
//  Created by rui on 2018/5/8.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit

class AppWindow: NSObject {
    
    class func keyboardWindow() -> UIView?  {
        var window = keyWindow()
        for win in UIApplication.shared.windows {
            
            if NSStringFromClass(win.classForCoder) == "UIRemoteKeyboardWindow" {
                window = win
            }
        }
        return window
    }
    
    class func keyWindow() -> UIView? {
       return UIApplication.shared.keyWindow
    }
}
