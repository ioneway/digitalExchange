//
//  Bundle+Extension.swift
//  tools_swift
//
//  Created by 王伟 on 2018/8/31.
//  Copyright © 2018年 王伟. All rights reserved.
//

import Foundation

public extension Bundle {
    
    /// EZSE: 加载xib
    //  Bundle.loadNib("ViewXibName", owner: self) //some UIView subclass
    //  self.addSubview(self.contentView)
    public class func loadNib(_ name: String, owner: AnyObject!) {
        _ = Bundle.main.loadNibNamed(name, owner: owner, options: nil)?[0]
    }
    
    /// EZSE: load xib
    /// Usage: let view: ViewXibName = Bundle.loadNib("ViewXibName")
    public class func loadNib<T>(_ name: String) -> T? {
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?[0] as? T
    }
}
