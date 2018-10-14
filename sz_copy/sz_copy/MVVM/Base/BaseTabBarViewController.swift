//
//  TabBarViewController.swift
//  RxSwiftMVVM
//
//  Created by 王伟 on 2017/10/31.
//  Copyright © 2017年 JianweiWang. All rights reserved.
//

import UIKit

class BaseTabBarViewController: BaseViewController<TabBarViewModel>{

    let vmTabBarController: UITabBarController = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vmTabBarController.view.frame = view.bounds
        addChildViewController(vmTabBarController)
        view.addSubview(vmTabBarController.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
