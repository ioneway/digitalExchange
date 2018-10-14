//
//  ActionSheetView.swift
//  Exchange
//
//  Created by 王伟 on 2018/10/10.
//  Copyright © 2018年 common. All rights reserved.
//


import UIKit


public protocol  ActionSheetDelegate: class {
    
    /// actionSheet 点击回调
    func actionSheet(actionSheet: ActionSheetView, selectedTitle: String)
}

/// 点击回调
public typealias ActionSheetClickedHandler = ((ActionSheetView, _ selectedTitle: String) -> Void)

public class ActionSheetView: UIView {
    // MARK: 属性
    /// 代理ActionSheetDelegate
    public var delegate: ActionSheetDelegate?
    /// 标题
    public var title: String?
    /// 选中的文字
    public var selectedText: String?
    /// 取消按钮title
    public var cancelButtonTitle: String?
    /// 标题颜色
    public var titleColor: UIColor
    /// 按钮文字颜色
    public var buttonColor: UIColor
    /// 选中的文字颜色
    public var selectedColor: UIColor?
    /// 选中的文字字体
    public var selectedFont: UIFont?
     /// destructive按钮背景颜色
    public var destructiveButtonBackgroundColor: UIColor? 

    
    /// 标题字体 默认
    public var titleFont: UIFont
    /// 按钮字体
    public var buttonFont: UIFont
    /// 标题行数 默认为0，即不限制
    public var titleLinesNumber: Int
    /// 标题Insets
    public var titleEdgeInsets: UIEdgeInsets
    /// 按钮高度
    public var buttonHeight: CGFloat
    /// 动画时间
    public var animationDuration: TimeInterval
    /// 分割线颜色
    public var separatorColor: UIColor
    /// 按钮高亮颜色
    public var buttonHighlightdColor: UIColor
    /// 是否可以滚动
    public var isScrollEnabled: Bool
    /// 显示按钮数量 （不能为负数）
    public var visibleButtonCount: Float = 0
    /// destructive按钮文字颜色
    public var destructiveButtonColor: UIColor
    /// destructive按钮位置
    public var destructiveButtonIndex: Int?
    /// 其他按钮标题
    private var otherButtonTitles: [String] = []
    /// 点击事件回调
    public var clickedHandler: ActionSheetClickedHandler?
    /// 是否可以点击其他区域
    public var canTouchToDismiss: Bool
    /// 内容View
    private var containerView: UIView!
    /// 标题
    private var titleLabel: UILabel!
    /// 其他按钮tableView
    private var tableView: UITableView!
    /// 背景
    private var backgroundView: UIView!
    /// 分割线
    private var divisionView: UIView!
    /// 取消按钮
    private var cancelButton: UIButton!
    /// 默认配置
    private var config: ActionSheetConfig = ActionSheetConfig.default
    /// 底部视图，用于适配iphonex底部34高度
    private var bottomView: UIView!
    
    private convenience init() {
        let frame = UIScreen.main.bounds
        self.init(frame: frame)
    }
    
    private override init(frame: CGRect) {
        
        cancelButtonTitle = config.cancelButtonTitle
        titleColor = config.titleColor
        buttonColor = config.buttonColor
        titleFont = config.titleFont
        buttonFont = config.buttonFont
        
        separatorColor = config.separatorColor
        destructiveButtonColor = config.destructiveButtonColor
        buttonHeight = config.buttonHeight
        animationDuration = config.animationDuration
        titleLinesNumber = config.titleLinesNumber
        titleEdgeInsets = config.titleEdgeInsets
        
        buttonHighlightdColor = config.buttonHighlightdColor
        canTouchToDismiss = config.canTouchToDismiss        
        
        isScrollEnabled = config.isScrollEnabled
        selectedFont = config.selectedFont
        selectedColor = config.selectedColor

        super.init(frame: frame)
        setupUI()
        
    }
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - cancelButtonTitle: 取消按钮标题
    ///   - otherButtonTitles: 其他按钮数组
    ///   - clickedHandler: 点击事件回调
    public convenience init(title: String? = nil,
                            selectedText:String? = nil,
                            cancelButtonTitle: String? = nil,
                            otherButtonTitles: [String] = [],
                            clickedHandler: ActionSheetClickedHandler? = nil) {
        self.init()
        self.title = title
        self.selectedText = selectedText
        self.otherButtonTitles = otherButtonTitles
        self.cancelButtonTitle = cancelButtonTitle
        self.clickedHandler = clickedHandler
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        backgroundView = UIVisualEffectView(effect: blurEffect)
        backgroundView.frame = self.bounds
        addSubview(backgroundView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewClicked))
        backgroundView.addGestureRecognizer(tapGesture)
        
        containerView = UIView()
        containerView.backgroundColor = config.backgroundColor
        addSubview(containerView)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)

        //
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: "cell")
        containerView.addSubview(tableView)
        
        // 分割线
        divisionView = UIView()
        divisionView.backgroundColor = separatorColor
        containerView.addSubview(divisionView)
        
        // 取消按钮
        cancelButton = UIButton(type: .custom)
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        containerView.addSubview(cancelButton)
        
        //底部视图，用于适配iphonex底部34高度
        bottomView = UIView()
        bottomView.backgroundColor = destructiveButtonBackgroundColor
        containerView.addSubview(bottomView)
    }
    
    /// 计算
    func setupSubViews() {
        
        if isScrollEnabled == true {
            assert(visibleButtonCount > 0, "visibleButtonCount 不能小于0")
        }
        
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        titleLabel.numberOfLines = titleLinesNumber
        titleLabel.text = title
        
        tableView.rowHeight = buttonHeight
    
        let contentWidth = self.frame.width
 
        var titleEdgeInsetsBottom = titleEdgeInsets.bottom
        if title != nil {
            let titleWidth = contentWidth - titleEdgeInsets.left - titleEdgeInsets.right
            let size = CGSize(width: titleWidth,
                              height: CGFloat.greatestFiniteMagnitude)
            var titleSize = titleLabel.sizeThatFits(size)
            titleSize = CGSize(width: titleWidth, height: ceil(titleSize.height)+1)
            
            titleLabel.frame = CGRect(x: titleEdgeInsets.left, y: titleEdgeInsets.top,
                                      width: titleSize.width, height: titleSize.height)
        } else {
            titleLabel.frame = CGRect.zero
            titleEdgeInsetsBottom = 0
        }
        
    
        // layout tableView
        var tableViewHeight: CGFloat
        if isScrollEnabled && visibleButtonCount != 0 {
            tableViewHeight = ceil(CGFloat(visibleButtonCount) * buttonHeight)
        } else {
            tableViewHeight = CGFloat(otherButtonTitles.count) * buttonHeight
        }
        
        tableView.isScrollEnabled = isScrollEnabled
        tableView.frame = CGRect(x: 0, y: titleLabel.frame.maxY+titleEdgeInsetsBottom,
                                 width: contentWidth, height: tableViewHeight)
        
        // 
        let divisionViewHeight: CGFloat = (cancelButtonTitle != nil) ? 5.0 : 0.0
        divisionView.frame = CGRect(x: 0, y: tableView.frame.maxY,
                                     width: contentWidth, height: divisionViewHeight)
        
        cancelButton.titleLabel?.font = buttonFont
        cancelButton.setTitleColor(destructiveButtonColor, for: .normal)
        
        cancelButton.setBackgroundImage(UIImage(color: destructiveButtonBackgroundColor ?? ColorAsset.BackGround.Level2.color), for: .normal)
        cancelButton.setBackgroundImage(UIImage(color: destructiveButtonBackgroundColor ?? ColorAsset.BackGround.Level2.color), for: .highlighted)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        
        if cancelButtonTitle != nil {
            cancelButton.frame = CGRect(x: 0, y: divisionView.frame.maxY,
                                        width: contentWidth, height: buttonHeight)
        } else {
            cancelButton.frame = CGRect(x: 0, y: divisionView.frame.maxY,
                                        width: contentWidth, height: 0)
        }
        
        // 添加背景
        bottomView.frame = CGRect(x: 0, y: cancelButton.frame.maxY,
                                  width: contentWidth, height: kBottom_HEIGHT)
   
        containerView.frame = CGRect(x: 0, y: self.frame.height - cancelButton.frame.maxY-kBottom_HEIGHT,
                                     width: contentWidth, height: cancelButton.frame.maxY+kBottom_HEIGHT)
    }
    
    
    /// 添加按钮
    ///
    /// - Parameters:
    ///   - buttonTitles: 标题数组
    public func append(buttonTitles: [String]) {
        otherButtonTitles.append(contentsOf: buttonTitles)
        tableView.reloadData()
        setupSubViews()
    }
    
    /// 在指定位置插入按钮
    ///
    /// - Parameters:
    ///   - buttonTitles: 标题数组
    ///   - index: 位置
    public func insert(buttonTitles: [String], at index: Int) {
        otherButtonTitles.insert(contentsOf: buttonTitles, at: index)
        tableView.reloadData()
        setupSubViews()
    }
    
    @objc func backgroundViewClicked() {
        cancelButtonClicked()
    }
    
    /// 显示ActionSheetView
    public func show() {

        let keyWindow = AppDelegate.default.window!
        keyWindow.addSubview(self)
        
        setupSubViews()
        containerView.frame = containerView.frame.offsetBy(dx: 0, dy: containerView.frame.height)
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            
            let frame = self.containerView.frame
            self.containerView.frame = frame.offsetBy(dx: 0, dy: -frame.height)
            
        }, completion: {(finished) in
            
            self.backgroundView.isUserInteractionEnabled = self.canTouchToDismiss
            
        })
    }
    
    /// 隐藏ActionSheetView
    public func dismiss() {
        cancelButtonClicked()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension ActionSheetView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherButtonTitles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ActionSheetCell
        cell.titleLabel.font = buttonFont
        cell.lineLayer.backgroundColor = separatorColor.cgColor
        cell.titleLabel.text = otherButtonTitles[indexPath.row]
        cell.backgroundColor = ColorAsset.BackGround.Level2.color

        if indexPath.row == destructiveButtonIndex {
            cell.titleLabel.textColor = destructiveButtonColor
        } else {
            cell.titleLabel.textColor = buttonColor
        }
        
        if cell.titleLabel.text == self.selectedText {
            cell.titleLabel.textColor = selectedColor
            cell.titleLabel.font = selectedFont
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if clickedHandler != nil {
            self.clickedHandler?(self, otherButtonTitles[indexPath.row])
        }else {
            self.delegate?.actionSheet(actionSheet: self, selectedTitle: otherButtonTitles[indexPath.row])
        }
        
        _dismiss()
    }
    
}

extension ActionSheetView {
    
    @objc func cancelButtonClicked() {
        if clickedHandler != nil {
            self.clickedHandler?(self, cancelButton.titleLabel?.text ?? "取消".local)
        }else {
            self.delegate?.actionSheet(actionSheet: self, selectedTitle: cancelButton.titleLabel?.text ?? "取消".local)
        }
        _dismiss()
    }
    
    private func _dismiss() {
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: { 
            
            let frame = self.containerView.frame
            self.containerView.frame = frame.offsetBy(dx: 0, dy: frame.height)
            self.backgroundView.alpha = 0.0
            
        }, completion: {(finished) in
            
            self.removeFromSuperview()
            
        })
    }
}


extension UIColor {
     convenience init(hex6: UInt32, alpha: Float = 1) {
        let divisor = CGFloat(255)
        let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((hex6 & 0x00FF00) >> 8) / divisor
        let blue    = CGFloat((hex6 & 0x0000FF) >> 0) / divisor
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}

extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 10, height: 10)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }

}
