//
//  SliderView.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/18.
//  Copyright © 2018 王伟. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SliderView: UIView {
    
    /// 滑动比例值，（0...1）
    public var _value: CGFloat = 0.0
    
    public var minValue: String = "0"
    
    public var maxValue: String {
        set {
            maxLabel.text = newValue
        }
        get {
            return maxLabel.text ?? "--"
        }
    }
    
    /// 竹节数
    public var nodeCount = 4
    
    /// 节点直径
    public var nodeDiam: CGFloat = 10.0
    
    /// 横线高度
    public var lineHeight: CGFloat = 2.0
    
    /// 间隙
    public var gap: CGFloat = 2.0
    
    //初始颜色
    public var normalColor = ColorAsset.Block.node.color
    //选中颜色
    public var _selectColor = UIColor.green
    
    
    private var _nodeBaseTag = 100
    private var _lineBaseTag = 1000
    
    private var tempLine = UIView()
    
    private var minLabel: UILabel = {
        let temp = UILabel()
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level10)
        temp.textColor = ColorAsset.Text.Level3.color
        temp.text = "0"
        return temp
    }()
    
    private lazy var maxLabel: UILabel = {
        let temp = UILabel()
        temp.font = FontAsset.HelveticaNeue_Light.size(.Level10)
        temp.textColor = ColorAsset.Text.Level3.color
        temp.text = "--"
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()
    {
        for index in 0...4 {
            let node = UIView(frame: CGRect.init(x: 0, y: 0, width: nodeDiam, height: nodeDiam))
            node.layer.cornerRadius = nodeDiam/2.0
            node.clipsToBounds = true
            if index == 0 {
                node.backgroundColor = _selectColor
            }else {
                node.backgroundColor = normalColor
            }
            
            node.tag = _nodeBaseTag + index
            self.addSubview(node)
        }
        
        
        for index in 0...3 {
            
            let line = UIView(frame: CGRect.init(x: 0, y: 0, width: _lineWith, height: lineHeight))
            line.layer.cornerRadius = lineHeight/2.0
            line.clipsToBounds = true
            line.backgroundColor = normalColor
            line.tag = _lineBaseTag + index
            self.addSubview(line)
        }
        
        self.addSubview(tempLine)
        tempLine.snp.makeConstraints{ (make) in
            make.left.equalTo(_seperateWith * 0 + nodeDiam + gap)
            make.width.equalTo(0)
            make.height.equalTo(lineHeight)
            make.centerY.equalTo(nodeDiam/2.0)
        }
        
        self.addSubview(minLabel)
        minLabel.snp.makeConstraints{ (make) in
            make.left.equalToSuperview()
            make.top.equalTo(nodeView(index: 0)!.snp.bottom).offset(3)
        }
        self.addSubview(maxLabel)
        maxLabel.snp.makeConstraints{ (make) in
            make.right.equalToSuperview()
            make.centerY.equalTo(minLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for nodeTag in 0...4 {
            let node = nodeView(index: nodeTag)
            
            node?.snp.makeConstraints{ (make) in
                make.left.equalTo(CGFloat(nodeTag) * _seperateWith)
                make.width.height.equalTo(nodeDiam)
                make.top.equalToSuperview()
            }
        }
        
        for lineTag in 0...3 {
            let line = lineView(index: lineTag)
            
            line?.snp.makeConstraints{ (make) in
                make.left.equalTo((_seperateWith * CGFloat(lineTag)) + nodeDiam + gap)
                make.width.equalTo(_lineWith)
                make.height.equalTo(lineHeight)
                make.centerY.equalTo(nodeDiam/2.0)
            }
        }
        
        minLabel.snp.updateConstraints{ (make) in
            make.left.equalToSuperview()
            make.top.equalTo(nodeView(index: 0)!.snp.bottom).offset(3)
        }
        
        maxLabel.snp.updateConstraints{ (make) in
            make.right.equalToSuperview()
            make.centerY.equalTo(minLabel)
        }
    }
    
    private var _lineWith: CGFloat {
        get {
            return _seperateWith - nodeDiam - 2 * gap
        }
    }
    
    private var _seperateWith: CGFloat {
        get {
            return (width - nodeDiam) / CGFloat(nodeCount)
        }
    }
    
    private func nodeView(index: Int) -> UIView? {
        return viewWithTag(_nodeBaseTag + index)
    }
    
    private func lineView(index: Int) -> UIView? {
        return viewWithTag(_lineBaseTag + index)
    }
    
    /// 重置为初始状态
    private func resetToNormal()
    {
        for lineTag in 0...3 {
            let line = lineView(index: lineTag)
            line?.backgroundColor = normalColor
        }
        for nodeTag in 0...4 {
            let node = nodeView(index: nodeTag)
            node?.backgroundColor = normalColor
        }
        
        let firstNode = nodeView(index: 0)
        firstNode?.backgroundColor = _selectColor
        tempLine.backgroundColor = normalColor
    }
    
    /// 重置为value == 1 状态
    private func resetToFill()
    {
        for lineTag in 0...3 {
            let line = lineView(index: lineTag)
            line?.backgroundColor = _selectColor
        }
        for nodeTag in 0...4 {
            let node = nodeView(index: nodeTag)
            node?.backgroundColor = _selectColor
        }
    }
    
    public var value: CGFloat {
        get {
            return CGFloat(_value)
        }
        set {
            _value = newValue
            valueVariable.value = _value
            
            /// 重置
            resetToNormal()
            
            if _value >= 1 {  // 满额
                _value = 1
                valueVariable.value = _value
                resetToFill()
                return
            }
            if _value <= 0 {  //初始状态
                _value = 0
                valueVariable.value = _value
                resetToNormal()
                return
            }
            
            let endIndex = Int(_value*width / _seperateWith)
            let temp = _value * width - _seperateWith * CGFloat(endIndex)
            if endIndex > 0 {
                for index in 0...endIndex-1 {
                    let node = nodeView(index: index)
                    node?.backgroundColor = _selectColor
                }
            }
            if temp >= 6 {
                let node = nodeView(index: endIndex)
                node?.backgroundColor = _selectColor
            }
            
            if endIndex > 0 {
                for index in 1...endIndex {
                    let line = lineView(index: index-1)
                    line?.backgroundColor = _selectColor
                }
            }
            
            tempLine.backgroundColor = _selectColor
            tempLine.snp.updateConstraints{ (make) in
                make.left.equalTo((_seperateWith * CGFloat(endIndex)) + nodeDiam + gap)
                make.width.equalTo(temp-10)
                make.height.equalTo(lineHeight)
                make.centerY.equalTo(nodeDiam/2.0)
            }
        }
    }
    
    public var valueVariable = Variable<CGFloat>(0.0)
    
    public var selectColor: UIColor {
        set {
            _selectColor = newValue
            value = _value
        }
        get {
            return _selectColor
        }
    }
}

extension SliderView {
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let pt  = touch?.location(in: self)
        self.value = (pt?.x ?? 0)/width
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let pt  = touch?.location(in: self)
        self.value = (pt?.x ?? 0)/width
    }
    
}



