//
//  ViewController.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/10.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit

class ViewController: BaseViewController<TabBarViewModel>, UITabBarControllerDelegate  {

    let vmTabBarController: UITabBarController = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vmTabBarController.view.frame = view.bounds
        addChildViewController(vmTabBarController)
        view.addSubview(vmTabBarController.view)
        
        let homeVC: HomeViewController = Router.viewController((viewModel?.homeViewModel)!) as! HomeViewController
        let homeNav = generateNav(rootVC: homeVC, title: "首页".local, selectedImage: ImgAsset.Tab_home_selected.image, normalImage: ImgAsset.Tab_home.image)
        
        let marketVC: MarketViewController = Router.viewController((viewModel?.marketViewModel)!) as! MarketViewController
        let marketNav = generateNav(rootVC: marketVC, title: "行情".local, selectedImage: ImgAsset.Tab_market_selected.image, normalImage: ImgAsset.Tab_market.image)
        
        let exchangeVC: ExchangeViewController = Router.viewController((viewModel?.exchangeViewModel)!) as! ExchangeViewController
        let exchangeNav = generateNav(rootVC: exchangeVC, title: "交易".local, selectedImage: ImgAsset.Tab_exchange_selected.image, normalImage: ImgAsset.Tab_exchange.image)
        
        let miningVC: MiningViewController = Router.viewController((viewModel?.miningViewModel)!) as! MiningViewController
        let miningNav = generateNav(rootVC: miningVC, title: "挖矿".local, selectedImage: ImgAsset.Tab_mining_selected.image, normalImage: ImgAsset.Tab_mining.image)
        
        let mineVC: MineViewController = Router.viewController((viewModel?.mineViewModel)!) as! MineViewController
        let mineNav = generateNav(rootVC: mineVC, title: "我的".local, selectedImage: ImgAsset.Tab_mine_selected.image, normalImage: ImgAsset.Tab_mine.image)
        
        self.vmTabBarController.viewControllers = [homeNav, marketNav, exchangeNav, miningNav, mineNav]
        NavigationControllerStack.push(homeNav)
        self.vmTabBarController
            .rx.didSelect
            .asObservable()
            .bind { (viewController) in
                NavigationControllerStack.pop()
                NavigationControllerStack.push(viewController as! UINavigationController)
            }.disposed(by: self.vmTabBarController.rx.disposeBag)
        
        self.vmTabBarController.tabBar.barTintColor = ColorAsset.BackGround.Level4.color
    }

    private func generateNav(rootVC: UIViewController,
                             title: String,
                             selectedImage: UIImage,
                             normalImage: UIImage) ->UINavigationController
    {
        let nav = UINavigationController(rootViewController: rootVC)
        let item = UITabBarItem()
        rootVC.title = title
        item.title = title
        item.image = normalImage
        item.selectedImage = selectedImage
        item.setTitleTextAttributes([.foregroundColor: ColorAsset.Text.Level3.color], for: .normal)
        item.setTitleTextAttributes([.foregroundColor: ColorAsset.Block.Red.color], for: .selected)
        nav.tabBarItem = item
        
        return nav
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

