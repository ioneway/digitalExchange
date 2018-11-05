//
//  HomeViewController.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/19.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit
import SDCycleScrollView
import RxSwift

let kHomeViewPagingBarHeight: CGFloat = 35

class HomeViewController: BaseViewController<HomeViewModel>, UIScrollViewDelegate{
    
    private var _options: HomeMenuOptions!
    private var _pagingVC: PagingMenuController!
    private lazy var sview: UIView = {
        let temp = UIView()
//        temp.frame = self.view.bounds
        temp.height = 10000
        temp.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    internal override func setupUI() {
        self.view.addSubview(contentScroll)
        contentScroll.addSubview(cycleView)
        contentScroll.addSubview(miniView)

        APPTransactionPair.default.sourceCoinsVariable.asObservable().subscribe(onNext: { value in
            log("首页币种\(value)")
            if value.count == 0 {
                return
            }
            
            self.viewModel?.subscriptSocketServer()
            
            self._options = HomeMenuOptions()
            self._pagingVC = PagingMenuController.init(options: self._options)
            self._pagingVC.view.backgroundColor = self.view.backgroundColor
            self.addChildViewController(self._pagingVC)
            let pagingMenuController = self.childViewControllers.first as! PagingMenuController
            pagingMenuController.setup(self._options)
            self.contentScroll.addSubview(self._pagingVC.view)
            self._pagingVC.view.snp.makeConstraints{ make in
                make.top.equalTo(self.miniView.snp.bottom).offset(25)
                make.height.equalTo(kSCREEN_HEIGHT - kNavi_HEIGHT - kHomeViewPagingBarHeight)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.width.equalTo(kSCREEN_WIDTH)
                make.bottom.equalTo(self.contentScroll).offset(-10)
            }
        }).disposed(by: _disposeBag)
        
        self.view.addSubview(navView)
    }
    
    internal override func configConstraints() {

        contentScroll.snp.makeConstraints{ make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        cycleView.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(193.x)
            make.left.equalToSuperview()
        }
        
        miniView.snp.makeConstraints{ make in
            make.top.equalTo(cycleView.snp.bottom).offset(-20)
            make.height.equalTo(300)
            make.left.equalToSuperview().offset(15.x)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(kSCREEN_WIDTH-30.x)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
       viewModel?.subscriptSocketServer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.cancelSocketServer()
    }
    
    internal override func bindViewModel() {
        
        let _ = viewModel?.bannerPicPaths.asObservable().bind{ result in
            self.cycleView.localizationImageNamesGroup = result
        }
        
        let _ = viewModel?.announcementTitles.asObservable().bind{ result in
            self.miniView.noticeTitleList = result 
        }
        
        let _ = viewModel?.todayDividendTotalModel.asObservable().bind{ result in
            self.miniView.todayPoundageAmountBtcTotal = result?.poundageAmountBtcTotal ?? "--.--"
            self.miniView.dividendBtcAmountPerM = result?.dividendBtcAmountPerM ?? "--.--"
        }
        
        let _ = viewModel?.yesterdayDividendTotalModel.asObservable().bind{ result in
            self.miniView.yesterdayPoundageAmountBtcTotal = result?.poundageAmountBtcTotal ?? "--.--"
        }
        
        let _ = viewModel?.exchangeTotalModel.asObservable().bind{ result in
            self.miniView.circulationTotal = result?.circulationTotal ?? "--.--"
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentScroll == scrollView {
            if contentScroll.contentOffset.y < 400 {
                if sview.superview == nil {
                    self.contentScroll.addSubview(sview)
                }
            }else {
                sview.removeFromSuperview()
            }
            
            let rect = _pagingVC.view.convert(_pagingVC.view.bounds, to: AppDelegate.default.window)
            log ("=======\(rect)")
            if (rect.minY <= 89) {
                //                scrollView.contentOffset.y = 0
            }
        }
    }
    
    //容器Scroll
    private lazy var contentScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        scroll.backgroundColor = ColorAsset.BackGround.Level3.color
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.delegate = self
        return scroll
    }()
    
    //轮播广告
    private lazy var cycleView: SDCycleScrollView = {
        let temp = SDCycleScrollView()
        temp.clickItemOperationBlock = {[weak self] (index) in
            self?.viewModel?.bannerPush(index: index)
        }
        temp.scrollDirection = .horizontal
        temp.autoScrollTimeInterval = 5.0
        temp.pageControlBottomOffset = 30.0
        temp.pageDotImage = ImgAsset.pageControl.image
        temp.pageControlDotSize = CGSize.init(width: 20.x, height: 3)
        temp.currentPageDotImage = ImgAsset.pageControl_selected.image
        return temp
    }()
    
    //挖矿分红数据界面
    private lazy var miniView: MininView = {
        let temp = MininView.init(frame: CGRect.zero)
        temp.noticeView.clickItemOperationBlock = {[weak self] (index) in
            self?.viewModel?.noticePush(index: index)
        }
        return temp
    }()
    
    //自定义导航栏试图
    private lazy var navView: HomeNavigationView = {
       let temp = HomeNavigationView.init(contentScroll , frame: CGRect.init(x: 0, y: 0, width: kSCREEN_WIDTH, height: kNavi_HEIGHT))
        temp.backgroundColor = ColorAsset.BackGround.Level2.color
       return temp
    }()
    
    private let _disposeBag = DisposeBag()
}


struct HomeMenuOptions: PagingMenuControllerCustomizable {
    
   static var marketVM_0: MarketTableViewModel =  {
        let temp = MarketTableViewModel()
        temp.coinName = APPTransactionPair.default.sourceCoins[0]
        return temp
    }()
    static var marketVM_1: MarketTableViewModel =  {
        let temp = MarketTableViewModel()
        temp.coinName = APPTransactionPair.default.sourceCoins[1]
        return temp
    }()
    static var marketVM_2: MarketTableViewModel =  {
        let temp = MarketTableViewModel()
        temp.coinName = APPTransactionPair.default.sourceCoins[2]
        return temp
    }()
    
   public var marketVC_0 = Router.viewController(marketVM_0) as! MarketTableViewController
   public var marketVC_1 = Router.viewController(marketVM_1) as! MarketTableViewController
   public var marketVC_2 = Router.viewController(marketVM_2) as! MarketTableViewController
    
    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: [marketVC_0, marketVC_1, marketVC_2])
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var height:CGFloat {
            return kHomeViewPagingBarHeight
        }
        var backgroundColor = ColorAsset.BackGround.Level3.color
        var selectedBackgroundColor = ColorAsset.BackGround.Level3.color
        var focusMode: MenuFocusMode {
            let color = ColorAsset.Block.Red.color
            return .underline(height: 4, color: color, horizontalPadding: 20, verticalPadding: 0)
        }
        var menuPosition: MenuPosition {
            return .top
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem_0(), MenuItem_1(), MenuItem_2()]
        }
    }
    
    static let color = ColorAsset.Text.Level3.color
    static let selectedColor = ColorAsset.Block.Red.color
    static let font = FontAsset.PingFangSC_Regular.size(.Level15)
    static let selectedFont = FontAsset.PingFangSC_Semibold.size(.Level15)
    
    struct MenuItem_0: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: APPTransactionPair.default.sourceCoins[0],
                                     color: color,
                                     selectedColor: selectedColor,
                                     font: font,
                                     selectedFont: selectedFont
            )
            return .multilineText(title: title, description: MenuItemText(text: ""))
        }
    }
    
    struct MenuItem_1: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: APPTransactionPair.default.sourceCoins[1],
                                     color: color,
                                     selectedColor: selectedColor,
                                     font: font,
                                     selectedFont: selectedFont
            )
            
            return .multilineText(title: title, description: MenuItemText(text: ""))
        }
    }
    
    struct MenuItem_2: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: APPTransactionPair.default.sourceCoins[2],
                                     color: color,
                                     selectedColor: selectedColor,
                                     font: font,
                                     selectedFont: selectedFont
            )
            
            return .multilineText(title: title, description: MenuItemText(text: ""))
        }
    }
}

