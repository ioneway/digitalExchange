//
//  SettingViewController.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/19.
//  Copyright © 2018 王伟. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController<SettingViewModel> {

    
    var customTitleLabel: UILabel = {
       let temp = UILabel()
        temp.font = FontAsset.PingFangSC_Semibold.size(.Level30)
        temp.textColor = ColorAsset.Text.Level1.color
        temp.text = "设置".local
        return temp
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
