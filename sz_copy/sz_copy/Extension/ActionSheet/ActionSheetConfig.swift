//
//  ActionSheetConfig.swift
//  Exchange
//
//  Created by 王伟 on 2018/10/10.
//  Copyright © 2018年 common. All rights reserved.
//


import UIKit

/// ActionSheetView配置
public class ActionSheetConfig {
    
    public static let `default` = ActionSheetConfig()
    // MARK: 属性
    /// 取消按钮title
    public var cancelButtonTitle: String?
    /// 标题颜色 默认0x888888
    public var titleColor = ColorAsset.Text.Level3.color
    /// 普通按钮文字颜色
    public var buttonColor = ColorAsset.Text.Level1.color
    /// 标题字体
    public var titleFont = FontAsset.PingFangSC_Regular.size(.Level14)
    /// 普通按钮字体
    public var buttonFont = FontAsset.PingFangSC_Regular.size(.Level16)
    /// 选中的的按钮字体
    public var selectedFont = FontAsset.PingFangSC_Regular.size(.Level16)
    /// 当前选中的的按钮文字颜色
    public var selectedColor = ColorAsset.Block.Drop.color
    /// 标题行数 默认为0，即不限制
    public var titleLinesNumber: Int = 0
    /// 标题Insets
    public var titleEdgeInsets =  UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    /// 按钮高度
    public var buttonHeight: CGFloat = 50.0
    /// 动画时间
    public var animationDuration: TimeInterval = 0.3
    /// 分割线颜色
    public var separatorColor = ColorAsset.Text.Level4.color.withAlphaComponent(0.15)
    /// 按钮高亮颜色
    public var buttonHighlightdColor =  ColorAsset.Block.Drop.color
    /// 是否可以滚动
    public var isScrollEnabled = false
    /// destructive按钮文字颜色
    public var destructiveButtonColor = ColorAsset.Text.Level3.color
    /// destructive按钮背景颜色
    public var destructiveButtonBackgroundColor = ColorAsset.BackGround.Level2.color
    /// 是否可以点击其他区域
    public var canTouchToDismiss = true
    
    /// 底部背景色
    public var backgroundColor = ColorAsset.BackGround.Level2.color

    
}
