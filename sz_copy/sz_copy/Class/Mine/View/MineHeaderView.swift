//
//  MineHeaderView.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/18.
//  Copyright © 2018 王伟. All rights reserved.
//

import Foundation
import UIKit
import NightNight

class MineHeaderView: UIView {
    
    var iconView: UIImageView = {
       let temp = UIImageView()
        temp.mixedImage = ImgAsset.portrait.mixImg
        return temp
    }()
    
    var idLabel: UILabel = {
        let temp = UILabel()
        temp.text = "ID:199****1664"
        temp.font = FontAsset.PingFangSC_Regular.size(.Level12)
        temp.mixedTextColor = ColorAsset.Text.Level2.mixColor
        return temp
    }()
    
    var arrowView: UIImageView = {
        let temp = UIImageView()
        temp.mixedImage = ImgAsset.arrow_right.mixImg
        return temp
    }()
    
    var nameLabel: UILabel = {
        let temp = UILabel()
        temp.text = "199****1664"
        temp.font = FontAsset.PingFangSC_Regular.size(.Level16)
        temp.mixedTextColor = ColorAsset.Text.Level5.mixColor
        return temp
    }()
    
    var cornerStoneView: UIImageView = {
        let temp = UIImageView()
        temp.mixedImage = ImgAsset.cornerStone.mixImg
        return temp
    }()
    
    /// 是否隐藏基石投资人标示
   public var cornerStoneHide: Bool  {
        set {
            cornerStoneView.isHidden = true
        }
        get {
            return cornerStoneView.isHidden
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mixedBackgroundColor = ColorAsset.Text.Level2.mixColor
        setupUI()
        configConstraints()
    }
    
    
    
    private func setupUI()
    {
        addSubview(iconView)
        addSubview(idLabel)
        addSubview(nameLabel)
        addSubview(arrowView)
        addSubview(cornerStoneView)
    }
    
    private func configConstraints()
    {
        iconView.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(29.x)
            make.top.equalToSuperview().offset(15)
        }
        
        idLabel.snp.makeConstraints{ make in
            make.left.equalTo(iconView.snp.right).offset(27.x)
            make.top.equalToSuperview().offset(23.x)
            make.height.equalTo(17)
        }
        
        nameLabel.snp.makeConstraints{ make in
            make.left.equalTo(idLabel)
            make.top.equalTo(idLabel.snp.bottom).offset(5.x)
            make.height.equalTo(22)
        }
        
        arrowView.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20.x)
            make.width.equalTo(8)
            make.height.equalTo(15)
        }
        
        cornerStoneView.snp.makeConstraints{ (make) in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(10.x)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
