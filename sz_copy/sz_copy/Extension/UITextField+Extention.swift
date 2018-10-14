//
//  UITextField+Extention.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/14.
//  Copyright © 2018 王伟. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
   public func showToolBar()
    {
        self.inputAccessoryView = toolBar()
    }
    
    private func toolBar() -> UIToolbar{
        let doneToolbar = UIToolbar()
        
        //左侧的空隙
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        //右侧的完成按钮
        let done: UIBarButtonItem = UIBarButtonItem(title: "完成", style: .done,
                                                    target: self,
                                                    action: #selector(doneButtonAction))
        
        var items:[UIBarButtonItem] = []
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        return doneToolbar
    }
    
    @objc private func doneButtonAction() {
        self.resignFirstResponder()
    }
}
