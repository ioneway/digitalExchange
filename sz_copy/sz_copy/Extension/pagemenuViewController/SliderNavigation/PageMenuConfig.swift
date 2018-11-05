//
//  PageMenuConfig.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/25.
//  Copyright © 2018 王伟. All rights reserved.
//

import Foundation
import UIKit

public enum PageMenuPosition {
    case top
    case bottom
}

public protocol PageMenuViewCustomizable {
    var backgroundColor: UIColor { get }
    var selectedBackgroundColor: UIColor { get }
    var height: CGFloat { get }
    var animationDuration: TimeInterval { get }
    var menuPosition: MenuPosition { get }
    var itemsOptions: [PageMenuItemViewCustomizable] { get }
}

public protocol PageMenuItemViewCustomizable {
    var font: UIFont { get }
    var text: String { get }
    var selectColor: UIColor { get }
    var normalColor: UIColor { get }
}

struct PageMenuConfig: PageMenuViewCustomizable {
    var height: CGFloat = 35.0
    var backgroundColor = ColorAsset.BackGround.Level3.color
    var selectedBackgroundColor = ColorAsset.BackGround.Level3.color
    var animationDuration: TimeInterval = 0.3
    var menuPosition: MenuPosition = .top
    var itemsOptions: [PageMenuItemViewCustomizable]
}
