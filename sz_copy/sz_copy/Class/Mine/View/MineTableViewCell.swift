//
//  MineTableViewCell.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/18.
//  Copyright © 2018 王伟. All rights reserved.
//

import UIKit

class MineTableViewCell: UITableViewCell {

    /// 数据结构
    struct Item {
        let icon: UIImage
        let title: String
    }
    
    var iconView: UIImageView = {
        let temp = UIImageView()
        return temp
    }()
    
    var titleLabel: UILabel = {
        let temp = UILabel()
        temp.font = FontAsset.PingFangSC_Regular.size(.Level14)
        temp.mixedTextColor = ColorAsset.Text.Level2.mixColor
        return temp
    }()
    
    var arrowView: UIImageView = {
        let temp = UIImageView()
        temp.mixedImage = ImgAsset.arrow_right.mixImg
        return temp
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(iconView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(arrowView)
        self.selectedBackgroundView = UIView()
        
        contentView.mixedBackgroundColor = ColorAsset.BackGround.Level3.mixColor
        self.mixedBackgroundColor = ColorAsset.BackGround.Level3.mixColor
        configConstraint()
    }
    
    func configConstraint() {
        iconView.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(22.x)
        }
        
        titleLabel.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(49.x)
        }
        
        arrowView.snp.makeConstraints{ (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20.x)
            make.width.equalTo(6)
            make.height.equalTo(11)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _model: Item = Item(icon: ImgAsset.arrow_right.image, title: "")
    
    public var model:Item {
        set {
            _model = model
            iconView.image = newValue.icon
            titleLabel.text = newValue.title
        }
        get {
            return _model
        }
        
    }

}


