//
//  HomeViewController.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/19.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExchangeViewController: BaseViewController<ExchangeViewModel> {
    /// 容器Scroll
     private var _contentScroll: UIScrollView = {
        let temp = UIScrollView()
        temp.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        temp.backgroundColor = ColorAsset.BackGround.Level3.color
        temp.showsVerticalScrollIndicator = false
        temp.showsHorizontalScrollIndicator = false
        temp.contentInsetAdjustmentBehavior = .never
        return temp
    }()
    
    /// 买卖方向切换控制器
    private lazy var _exchangeDirectionControl: ExchangeDirectionControl = {
       let temp = ExchangeDirectionControl()
        temp.delegate = self
        temp.direction = .buy
        return temp
    }()
    
    /// 价格类型选择按钮 （限价 市价）
    private lazy var _priceTypeBtn: DropDownBtn = {
        let temp = DropDownBtn.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 100))
        temp.delegate = self
        return temp
    }()
    
    /// 价格输入框
    private lazy var _priceInputView: PriceInputView = {
        let temp = PriceInputView()
        return temp
    }()
    
    /// 法币价格（价格输入框下侧）
    private lazy var _currencyPriceLabel: UILabel = {
        let temp = UILabel()
        temp.textColor = ColorAsset.Text.Level4.color
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level12)
        temp.textAlignment = .center
        temp.text = "≈--"
        return temp
    }()
    
    /// 数量输入框
    private lazy var _numberInputView: NumberInputView = {
        let temp = NumberInputView()
        return temp
    }()
    
    /// 可用币数量（数量输入框下侧）
    private lazy var _canUseCoinNumLabel: UILabel = {
        let temp = UILabel()
        temp.textColor = ColorAsset.Text.Level4.color
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level12)
        temp.textAlignment = .center
        temp.text = "可用".local + " " + "--"
        return temp
    }()
    
    private lazy var _sliderView: SliderView = {
        let temp = SliderView.init()
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.exchangeDirectionVariable.value = .sell
        viewModel?.priceTypeVariable.value = .market
        
        if #available(iOS 11.0, *) {
            _contentScroll.contentInsetAdjustmentBehavior = .never
        }
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubview(_contentScroll)
        _contentScroll.addSubview(_exchangeDirectionControl)
        _contentScroll.addSubview(_priceTypeBtn)
        _contentScroll.addSubview(_priceInputView)
        _contentScroll.addSubview(_currencyPriceLabel)
        _contentScroll.addSubview(_numberInputView)
        _contentScroll.addSubview(_canUseCoinNumLabel)
        _contentScroll.addSubview(_sliderView)
    }
    
    override func configConstraints() {
        
        _contentScroll.snp.makeConstraints{ make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        _exchangeDirectionControl.snp.makeConstraints{ make in
            make.width.equalTo(190.x)
            make.top.equalToSuperview().offset(15 + kNavi_HEIGHT)
            make.height.equalTo(34)
            make.left.equalToSuperview().offset(15.x)
        }
        
        _priceTypeBtn.snp.makeConstraints{ make in
            make.top.equalTo(_exchangeDirectionControl.snp.bottom).offset(15)
            make.left.equalTo(_exchangeDirectionControl)
            make.width.equalTo(50.x)
            make.height.equalTo(28)
        }
        
        _priceInputView.snp.makeConstraints{ make in
            make.left.equalTo(_exchangeDirectionControl)
            make.width.equalTo(_exchangeDirectionControl)
            make.height.equalTo(50)
            make.top.equalTo(_exchangeDirectionControl.snp.bottom).offset(51)
        }
        
        _currencyPriceLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(_priceInputView)
            make.top.equalTo(_priceInputView.snp.bottom).offset(5)
        }
        
        _numberInputView.snp.makeConstraints{ make in
            make.left.equalTo(_priceInputView)
            make.top.equalTo(_priceInputView.snp.bottom).offset(30)
            make.width.height.equalTo(_priceInputView)
        }
        
        _canUseCoinNumLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(_numberInputView)
            make.top.equalTo(_numberInputView.snp.bottom).offset(5)
        }
        
        _sliderView.snp.makeConstraints{ (make) in
            make.left.equalTo(_numberInputView)
            make.top.equalTo(_canUseCoinNumLabel.snp.bottom).offset(20)
            make.height.equalTo(15)
            make.width.equalTo(190.x)
        }

    }
    
    override func bindViewModel() {
        
        /// 买卖方向监视
        let _ = viewModel?.exchangeDirectionVariable.asObservable().bind { result in
            self._exchangeDirectionControl.direction = result
        }
        
        /// 价格类型监视，价格类型按钮值的变化，actionsheet选中值的变化，均由viewmodel改变
        let _ = viewModel?.priceTypeVariable.asObservable().bind { result in
            self._priceTypeBtn.text = result
        }
        
        /// 当前币币价格双向数据框绑定
       let _ = _priceInputView.textVariable <-> (viewModel?.coinPriceVariable ?? Variable(""))
        
        /// 当前法币价格labe单向绑定
        let _ = viewModel?.currencyPriceVariable.asObservable().bind { result in
            self._currencyPriceLabel.text = result
        }
        
        /// 数量输入框的双向绑定
//        let _ = _numberInputView.textVariable <-> (viewModel?.numberVariable ?? Variable(""))
        
        let _ = _numberInputView.textVariable.asObservable().bind { result in
            self.viewModel?.numberVariable.value = result
            if result.decimal.decimalValue != Decimal.nan {
                        self._sliderView.value = CGFloat((result.decimal / 1000.decimal).doubleValue)
                    }
        }
        
        /// 数量输入框 币种名称绑定
        let _ = viewModel?.coinCodeVariable.asObservable().bind { result in
            self._numberInputView.coinName = result
        }
        
//        /// 绑定：当viewmodel对应值发生变化时，sliderView的值变化
//        let _ = viewModel?.numberVariable.asObservable().bind { result in
//            if result.decimal.decimalValue != Decimal.nan{
//                self._sliderView.value = CGFloat((result.decimal / 1000.decimal).doubleValue)
//            }
//        }
        
        /// 绑定：当sliderView的值变化时，数量输入框的值变化，同时viewmodel对应值随同变化，
        let _ = _sliderView.valueVariable.asObservable().bind { result in
            self._numberInputView.text = Double(result*CGFloat(1000)).decimal.string
            self._viewModel?.numberVariable.value = Double(result*CGFloat(1000)).decimal.string
        }
        
        /// 可用币数额的绑定
        let _ = viewModel?.canUseNumVariable.asObservable().bind { result in
            self._canUseCoinNumLabel.text = result
        }
    }
}


extension ExchangeViewController: ExchangeDirectionControlDelegate, ActionSheetDelegate, DropDownBtnDelegate{
    
    func exchangeDirectionControlTaped(_ directionView: ExchangeDirectionControl) {
        //TODO: 获取用户资产，并跟新部分相关UI
        if directionView.direction == .buy { //买入
          // 价格输入框加减按钮变色 买入 绿色
            _priceInputView.symbolColor = ColorAsset.Block.Increase.color
            _sliderView.selectColor = ColorAsset.Block.Increase.color
        }else { //卖出
            // 价格输入框加减按钮变色 卖出 红色
            _priceInputView.symbolColor = ColorAsset.Block.Drop.color
            _sliderView.selectColor = ColorAsset.Block.Drop.color
        }
    }
    
    func actionSheet(actionSheet: ActionSheetView, selectedTitle: String) {
        viewModel?.priceTypeVariable.value = (PriceType(rawValue: selectedTitle) ?? .limit)
        if selectedTitle != PriceType.limit.rawValue { // 限价
            
        } else {
            
        }
        log("点击了：\(selectedTitle)")
    }
    
    func dropDownBtnClicked(view: DropDownBtn) {
        let otherButtonTitles = [PriceType.limit.rawValue.local, PriceType.market.rawValue.local]
        let actionSheet = ActionSheetView(selectedText: viewModel?.priceTypeVariable.value.rawValue.local,
                                          cancelButtonTitle: "取消".local,
                                          otherButtonTitles: otherButtonTitles,
                                          clickedHandler: nil)
        actionSheet.delegate = self
        actionSheet.show()
    }
}
