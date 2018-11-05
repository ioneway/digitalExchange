//
//  PageMenuView.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/26.
//  Copyright © 2018 王伟. All rights reserved.
//

import UIKit

class PageMenuView: UIScrollView {

    var config: PageMenuViewCustomizable!
    fileprivate let contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView(frame: .zero))
    
    lazy fileprivate var underlineView: UIView = {
        return UIView(frame: .zero)
    }()
    
    init(config: PageMenuViewCustomizable) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: config.height))
        self.config = config
        
        setupScrollView()
        setupContentView()
        layoutContentView()
    }
    
    private func setupScrollView() {
        backgroundColor = config.backgroundColor
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isDirectionalLockEnabled = true
        scrollsToTop = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupContentView() {
        addSubview(contentView)
    }
    
    fileprivate func layoutContentView() {
        contentView.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
