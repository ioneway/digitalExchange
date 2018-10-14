//
//  ExchangeDirectionControl.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/12.
//  Copyright © 2018 王伟. All rights reserved.
//

import UIKit

protocol  ExchangeDirectionControlDelegate: class {
    /// 交易方向变化。 取属性
    func exchangeDirectionControlTaped(_ directionView:ExchangeDirectionControl)
}


class ExchangeDirectionControl: UIView {
    
    weak var delegate: ExchangeDirectionControlDelegate?
    
    /// 交易方向：买入，卖出
    var direction: ExchangeDirection = .buy {
        didSet {
            if oldValue != direction {
                exchangeDirection()
            }
        }
    }
    
    private let buyBtn: UIButton = {
        let temp = UIButton()
        temp.setTitle(ExchangeDirection.buy.rawValue.local, for: .normal)
        temp.setTitleColor(ColorAsset.Text.Level3.color, for: .normal)
        temp.titleLabel?.font = FontAsset.PingFangSC_Regular.size(.Level16)
        temp.addTarget(self, action: #selector(itemsTaped(sender:)), for: .touchUpInside)
        
        return temp
    }()
    
    private let sellBtn: UIButton = {
        let temp = UIButton()
        temp.setTitle(ExchangeDirection.sell.rawValue.local, for: .normal)
        temp.setTitleColor(ColorAsset.Text.Level3.color, for: .normal)
        temp.titleLabel?.font = FontAsset.PingFangSC_Regular.size(.Level16)
        temp.addTarget(self, action: #selector(itemsTaped(sender:)), for: .touchUpInside)
        
        return temp
    }()
    
    private let lineView: UIView = {
        let temp = UIView()
        temp.backgroundColor = ColorAsset.Text.Level4.color
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        addSubview(buyBtn)
        addSubview(sellBtn)
        addSubview(lineView)
        
        buyBtn.snp.makeConstraints{ (make) in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.left.top.bottom.equalToSuperview()
        }

        sellBtn.snp.makeConstraints{ (make) in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.right.top.bottom.equalToSuperview()
        }
        
        lineView.snp.makeConstraints{ (make) in
            make.width.equalTo(1)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        exchangeDirection()
    }
    
    @objc private func itemsTaped(sender: UIButton) {
        if sender == buyBtn {   //买入
            self.direction = .buy
        } else {                //卖出
            self.direction = .sell
        }
    }
    
    private func exchangeDirection() {
        changeThemeToNormal()
        if direction == .buy {  //买入
            buyBtn.setTitleColor(ColorAsset.Block.Increase.color, for: .normal)
            
            buyBtn.drawBorder(positions: [.left, .top, .bottom], borderColor: ColorAsset.Block.Increase.color)
            lineView.backgroundColor = ColorAsset.Block.Increase.color

        } else {                //卖出
            sellBtn.setTitleColor(ColorAsset.Block.Drop.color, for: .normal)
            sellBtn.drawBorder(positions: [.right, .top, .bottom], borderColor: ColorAsset.Block.Drop.color)
            lineView.backgroundColor = ColorAsset.Block.Drop.color
        }
        
        self.delegate?.exchangeDirectionControlTaped(self)
    }
    
    private func changeThemeToNormal() {
        sellBtn.setTitleColor(ColorAsset.Text.Level3.color, for: .normal)
        sellBtn.borderWith = 1
        sellBtn.drawBorder(positions: [.right, .top, .bottom], borderColor: ColorAsset.Text.Level4.color)
        
        buyBtn.setTitleColor(ColorAsset.Text.Level3.color, for: .normal)
        buyBtn.borderWith = 1
        buyBtn.drawBorder(positions: [.left, .top, .bottom], borderColor: ColorAsset.Text.Level4.color)
        
        lineView.backgroundColor = ColorAsset.Text.Level4.color
    }
}

