//
//  DropDownBtn.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/14.
//  Copyright © 2018 王伟. All rights reserved.
//

import UIKit

protocol DropDownBtnDelegate: class {
    /// 价格类型按钮 点击
    func dropDownBtnClicked(view:DropDownBtn)
}


class DropDownBtn: UIView {
    
    private lazy var textLabel: UILabel = {
        let temp = UILabel()
        temp.text = PriceType.limit.rawValue
        temp.font = FontAsset.PingFangSC_Regular.size(.Level14)
        temp.textColor = ColorAsset.Text.Level2.color
        temp.isUserInteractionEnabled = true
        return temp
    }()
    
    private lazy var imgView: UIImageView = {
        let img = ImgAsset.downBtn.image
        let temp = UIImageView.init(image: img)
        temp.isUserInteractionEnabled = true
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addOnClickListener(target: self, action: #selector(tapClick(gesture:)))
        self.setupUI()
        self.configConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(textLabel)
        addSubview(imgView)
    }
    
    private func configConstraints() {
        
        textLabel.snp.makeConstraints{ (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        imgView.snp.makeConstraints{ (make) in
            make.left.equalTo(textLabel.snp.right).offset(2)
            make.centerY.equalTo(textLabel)
        }
    }
    
    public var text: PriceType {
        set {
            textLabel.text = newValue.rawValue
        }
        get {
            return PriceType(rawValue: textLabel.text ?? "") ?? .limit
        }
    }
    public weak var delegate: DropDownBtnDelegate?
    
    @objc private func tapClick(gesture: UITapGestureRecognizer) {
        let view = gesture.view as! DropDownBtn
        
        if let delegate = delegate {
            delegate.dropDownBtnClicked(view:view)
        }
    }
}

