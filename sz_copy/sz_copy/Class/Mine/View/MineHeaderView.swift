//
//  MineHeaderView.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/18.
//  Copyright © 2018 王伟. All rights reserved.
//

import Foundation
import UIKit

class MineHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorAsset.BackGround.Level2.color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
