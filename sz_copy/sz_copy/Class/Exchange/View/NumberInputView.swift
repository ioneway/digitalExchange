//
//  NumberInputView.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/13.
//  Copyright © 2018 王伟. All rights reserved.
//

import UIKit

class NumberInputView: UIView {

    /// 价格步长
    public var numStep = 0.1

    private lazy var coinNameLabel: UILabel = {
        var temp = UILabel()
        temp.text = _coinName.local
        temp.textAlignment = .center
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level16)
        temp.textColor = ColorAsset.Text.Level3.color
        
        return temp
    }()
    
    private lazy var textField: UITextField = {
        var temp = UITextField()
        temp.borderStyle = .none
        temp.keyboardType = .decimalPad
        temp.showToolBar()
        temp.font = FontAsset.HelveticaNeue_Bold.size(.Level16)
        temp.textColor = ColorAsset.Text.Level1.color
        temp.textAlignment = .left
        temp.placeholder = "数量".local
        temp.setValue(ColorAsset.Text.Level4.color, forKeyPath: "_placeholderLabel.textColor")
        
       return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.configConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.layer.borderColor = ColorAsset.Text.Level4.color.cgColor
        self.layer.borderWidth = 1
        
        addSubview(coinNameLabel)
        addSubview(textField)
    }
    
    private func configConstraints() {
        
        coinNameLabel.snp.makeConstraints{(make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.24)
        }
        
        textField.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(14.x)
            make.right.equalTo(coinNameLabel.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
    private var _coinName: String = "SZ"
    
    /// 币种代码
    public var coinName: String {
        set{
            _coinName = newValue
            coinNameLabel.text = newValue
        }
        get {
            return coinNameLabel.text!
        }
    }
    
    /// 数量输入框中的字符串
    public var text: String {
        set {
            textField.rx.textInput.base.text = newValue
        }
        get {
            return textField.text ?? ""
        }
    }
    
    /// 用于双向绑定数据，
    public lazy var textVariable = {
        return textField.rx.textInput
    }()
    
   
}
