//
//  UIView+Tools.swift
//  tools_swift
//
//  Created by 王伟 on 2018/8/26.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit

extension UIView {
    var screenshot: UIImage?
    {
        // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
}
