//
//  HomeNavigationView.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/8.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit
import CoreGraphics

class HomeNavigationView: UIView {

    var scroll: UIScrollView?
    
    convenience init(_ scroll: UIScrollView?, frame: CGRect) {
        self.init(frame: frame)
        self.scroll = scroll
        self.scroll?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        self.addSubview(titleLabel)
        titleLabel.center = self.center
        titleLabel.centerY = self.centerY+10
    }
    
    override init(frame: CGRect) {
        self.scroll = UIScrollView()
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath != "contentOffset" { return }
        let offset = change?[NSKeyValueChangeKey.newKey] as! CGPoint
        var alpha = offset.y / 99.0
        if alpha > 1.0 { alpha = 1 }
        if alpha < 0 { alpha = 0 }
        self.alpha = alpha
        self.titleLabel.alpha = alpha
    }
    
    deinit {
        if let scroll = scroll {
            scroll.removeObserver(self, forKeyPath: "contentOffset")
        }
    }
    
    
    let titleLabel: UILabel = {
        let temp = UILabel.init()
        temp.font = FontAsset.PingFangSC_Regular.size(.Level16)
        temp.textColor = ColorAsset.White.color
        temp.textAlignment = .center
        temp.text = "首页".local
        temp.sizeToFit()
        temp.alpha = 0
        return temp
    }()
    
}
