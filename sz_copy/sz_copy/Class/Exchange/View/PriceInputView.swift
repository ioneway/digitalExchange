//
//  PriceInputView.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/13.
//  Copyright © 2018 王伟. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PriceInputView: UIView {

    /// 价格步长
    public var priceStep = 0.1
    
    private var plusBtn: UIButton = {
       var temp = UIButton(type: UIButtonType.custom)
        let img = ImgAsset.plus.image
        temp.setImage(img.withRenderingMode(.alwaysTemplate), for: .normal)
        temp.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        
        return temp
    }()
    
    private var minusBtn: UIButton = {
        var temp = UIButton(type: UIButtonType.custom)
        let img = ImgAsset.minus.image
        temp.setImage(img.withRenderingMode(.alwaysTemplate), for: .normal)
        temp.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        
        return temp
    }()
    
    private var textField: UITextField = {
        var temp = UITextField()
        temp.borderStyle = .none
        temp.showToolBar()
        temp.keyboardType = .decimalPad
        temp.font = FontAsset.HelveticaNeue_Bold.size(.Level16)
        temp.textColor = ColorAsset.Text.Level1.color
        temp.textAlignment = .center
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
        
        addSubview(plusBtn)
        addSubview(minusBtn)
        addSubview(textField)
    }
    
    private func configConstraints() {
        plusBtn.snp.makeConstraints{(make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.24)
        }
        
        minusBtn.snp.makeConstraints{(make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.24)
        }
        
        let seperateLineLeft = UIView()
        addSubview(seperateLineLeft)
        seperateLineLeft.backgroundColor = ColorAsset.BackGround.Level2.color
        seperateLineLeft.snp.makeConstraints{ make in
            make.left.equalTo(minusBtn.snp.right)
            make.width.equalTo(0.5)
            make.top.bottom.equalToSuperview()
        }
        
        let seperateLineRight = UIView()
        addSubview(seperateLineRight)
        seperateLineRight.backgroundColor = ColorAsset.BackGround.Level2.color
        seperateLineRight.snp.makeConstraints{ make in
            make.right.equalTo(plusBtn.snp.left)
            make.width.equalTo(0.5)
            make.top.bottom.equalToSuperview()
        }
        
        textField.snp.makeConstraints{ make in
            make.left.equalTo(seperateLineLeft.snp.right)
            make.right.equalTo(seperateLineRight.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func btnClick(sender: UIButton){
       if textField.text?.isNumber == false {
            return
        }
        
        if sender == plusBtn {  //加法
            let price = (textField.text?.decimal ?? "0".decimal) + priceStep.decimal
            textField.text = price.string
        }else {                 //减法
            let price = (textField.text?.decimal ?? "0".decimal) - priceStep.decimal
            textField.text = price.string
        }
        
    }
    
    /// 左右符号按钮的颜色
    public var symbolColor: UIColor {
        set{
            plusBtn.tintColor = newValue
            minusBtn.tintColor = newValue
        }
        get {
            return plusBtn.tintColor
        }
    }
    
    /// 价格输入框中的字符串
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


