//
//  MininView.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/26.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit
import SDCycleScrollView
import SnapKit
import RxSwift
import RxCocoa

class MininView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ColorAsset.BackGround.Level2.color
        
        self.layer.cornerRadius = 4.0
        self.clipsToBounds = true
        
        setupUI()
        configConstraints()
    }
    
    private func setupUI() {
        
        addSubview(noticeIcon)
        addSubview(noticeView)
        
        addSubview(titleLabel_0)
        addSubview(detailLabel_0)
        
        addSubview(titleLabel_1)
        addSubview(detailLabel_1)
        
        addSubview(titleLabel_2)
        addSubview(detailLabel_2)
        
        addSubview(titleLabel_3)
        addSubview(detailLabel_3)
        
        addSubview(detailLabel_4)
        addSubview(detailLabel_5)
        
        addSubview(firstLineView)
        addSubview(secondLineView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    private func configConstraints() {
        noticeIcon.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(18.x)
            make.top.equalToSuperview().offset(14)
            make.width.equalTo(16.x)
            make.height.equalTo(13.x)
        }

        noticeView.snp.makeConstraints{ make in
            make.left.equalTo(noticeIcon.snp.right).offset(8.x)
            make.centerY.equalTo(noticeIcon)
            make.right.equalToSuperview().offset(-15.x)
            make.height.equalTo(27)
        }
        
        firstLineView.snp.makeConstraints{ make in
            make.left.equalToSuperview()
            make.top.equalTo(noticeIcon.snp.bottom).offset(11)
            make.height.equalTo(2)
            make.width.equalToSuperview()
        }
        
        titleLabel_0.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(30.x)
            make.top.equalTo(firstLineView.snp.bottom).offset(25)
        }
        
        detailLabel_0.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(30.x)
            make.top.equalTo(titleLabel_0.snp.bottom).offset(4)
        }
        
        detailLabel_1.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(30.x)
            make.top.equalTo(detailLabel_0.snp.bottom).offset(6)
        }
        
        titleLabel_1.snp.makeConstraints{ make in
            make.left.equalTo(detailLabel_1.snp.right).offset(7.x)
            make.centerY.equalTo(detailLabel_1.snp.centerY)
        }
        
        secondLineView.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(30.x)
            make.top.equalTo(titleLabel_1.snp.bottom).offset(25)
            make.right.equalToSuperview().offset(-30.x)
            make.height.equalTo(1)
        }
        
        titleLabel_2.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(30.x)
            make.top.equalTo(secondLineView.snp.bottom).offset(30)
        }
        
        detailLabel_2.snp.makeConstraints{ make in
            make.right.equalToSuperview().offset(-29.x)
            make.centerY.equalTo(titleLabel_2.snp.centerY)
        }
        
        titleLabel_3.snp.makeConstraints{ make in
            make.left.equalTo(titleLabel_2)
            make.top.equalTo(titleLabel_2.snp.bottom).offset(24)
        }
        
        detailLabel_3.snp.makeConstraints{ make in
            make.right.equalToSuperview().offset(-29.x)
            make.centerY.equalTo(titleLabel_3.snp.centerY)
        }
        
        detailLabel_4.snp.makeConstraints{ make in
            make.right.equalToSuperview().offset(-11.x)
            make.centerY.equalTo(titleLabel_2.snp.centerY)
        }
        
        detailLabel_5.snp.makeConstraints{ make in
            make.right.equalToSuperview().offset(-11.x)
            make.centerY.equalTo(titleLabel_3.snp.centerY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var noticeTitleList: [Any] {
        set {
            noticeView.titlesGroup = newValue
        }
        get {
            return noticeView.titlesGroup ?? [Any]()
        }
    }
    
    public var todayPoundageAmountBtcTotal: String {
        set {
            detailLabel_0.text = newValue
        }
        get {
            return detailLabel_0.text ?? "--.--"
        }
    }
    public var dividendBtcAmountPerM: String {
        set {
            detailLabel_1.text = newValue
        }
        get {
            return detailLabel_1.text ?? "--.--"
        }
    }
    public var yesterdayPoundageAmountBtcTotal: String {
        set {
            detailLabel_2.text = newValue
        }
        get {
            return detailLabel_2.text ?? "--.--"
        }
    }
    public var circulationTotal: String {
        set {
            detailLabel_3.text = newValue
        }
        get {
            return detailLabel_3.text ?? "--.--"
        }
    }
    
    //通知栏左侧图标
    private lazy var noticeIcon: UIImageView = {
        let temp = UIImageView.init(image: ImgAsset.notice.image)
        return temp
    }()
    
    //通知栏
    public lazy var noticeView: SDCycleScrollView = {
        let temp = SDCycleScrollView(frame: CGRect.zero)
        temp.scrollDirection = .vertical
        temp.onlyDisplayText = true
        temp.autoScrollTimeInterval = 3.5
        temp.titlesGroup = []
        temp.titleLabelTextColor = ColorAsset.Text.Level5.color
        temp.titleLabelTextFont = FontAsset.PingFangSC_Regular.size(.Level12)
        temp.titleLabelBackgroundColor = UIColor.clear
        return temp
    }()
    
    //分割线
    private lazy var firstLineView: UIView = {
        let temp = UIView()
        temp.backgroundColor = ColorAsset.Block.Seperate.color
        temp.alpha = 0.1
        return temp
    }()
    
    //label: 今日待分配收入累计折合
    private lazy var titleLabel_0: UILabel = {
        let temp = UILabel()
        temp.textColor = ColorAsset.Text.Level2.color
        temp.font = FontAsset.PingFangSC_Regular.size(.Level12)
        temp.text = "今日待分配收入累计折合".local
        return temp
    }()
    
    //今日待分配收入值，红色label
    private lazy var detailLabel_0: UILabel = {
        let temp = UILabel()
        temp.textColor = ColorAsset.Block.Red.color
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level20)
        temp.text = "--.--".local
        return temp
    }()
    
    //值 每百万sz待分配，
    private lazy var detailLabel_1: UILabel = {
        let temp = UILabel()
        temp.textColor = ColorAsset.Text.Level1.color
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level14)
        temp.text = "--.--".local
        return temp
    }()
    
    //标题： (今日每百万SZ待分配收入)，
    private lazy var titleLabel_1: UILabel = {
        let temp = UILabel()
        temp.textColor = ColorAsset.Text.Level2.color
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level12)
        temp.text = "(今日每百万SZ待分配收入)".local
        return temp
    }()
    
    // 第二个分割线
    private lazy var secondLineView: UIView = {
        let temp = UIView()
        temp.backgroundColor = ColorAsset.Block.Seperate.color
        temp.alpha = 0.2
        return temp
    }()
    
    // 标题: 昨日挖矿产出，
    private lazy var titleLabel_2: UILabel = {
        let temp = UILabel()
        temp.textColor = ColorAsset.Text.Level2.color
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level12)
        temp.text = "昨日挖矿产出".local
        return temp
    }()
    
    //值: 昨日挖矿产出，
    private lazy var detailLabel_2: UILabel = {
        let temp = UILabel()
        temp.textColor = ColorAsset.Text.Level1.color
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level12)
        temp.text = "--.--".local
        return temp
    }()
    
    
    //标题: 市场流通量，
    private lazy var titleLabel_3: UILabel = {
        let temp = UILabel()
        temp.textColor = ColorAsset.Text.Level2.color
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level12)
        temp.text = "市场流通量".local
        return temp
    }()
    
    //值:  市场流通量，
    private lazy var detailLabel_3: UILabel = {
        let temp = UILabel()
        temp.textColor = ColorAsset.Text.Level1.color
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level12)
        temp.text = "--.--".local
        return temp
    }()
    
    //昨日挖矿产出。单位SZ
    private lazy var detailLabel_4: UILabel = {
        let temp = UILabel()
        temp.textColor = ColorAsset.Text.Level2.color
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level12)
        temp.text = "SZ".local
        return temp
    }()
    
    //市场流通量。单位SZ
    private lazy var detailLabel_5: UILabel = {
        let temp = UILabel()
        temp.textColor = ColorAsset.Text.Level2.color
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level12)
        temp.text = "SZ".local
        return temp
    }()
    

}

//extension Reactive where Base: SDCycleScrollView {
//    public var localizationImageNamesGroup: ControlProperty<[Any]> {
//        return value
//    }
//
//    public var value: ControlProperty<[Any]> {
//        return base.rx.controlPropertyWithDefaultEvents(
//            getter: { textField in
//                textField.text
//            },
//            setter: { textField, value in
//                // This check is important because setting text value always clears control state
//                // including marked text selection which is imporant for proper input
//                // when IME input method is used.
//                if textField.text != value {
//                    textField.text = value
//                }
//        }
//        )
//    }
//}






