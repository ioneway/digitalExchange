//
//  UIButton+border.swift
//  Exchange
//
//  Created by 王伟 on 2018/8/10.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit

public enum BorderPosition {
    case left
    case right
    case top
    case bottom
}


private var borderWith_Key: Void?
private var borderColor_Key: Void?
private var leftBorderCorlor_Key: Void?
private var rightBorderCorlor_Key: Void?
private var topBorderCorlor_Key: Void?
private var bottomBorderCorlor_Key: Void?
private var leftBorder_Key: Void?
private var rightBorder_Key: Void?
private var topBorder_Key: Void?
private var bottomBorder_Key: Void?

extension UIButton {
    var borderWith: CGFloat {
        get {
            return objc_getAssociatedObject(self, &borderWith_Key) as! CGFloat
        }
        set(newValue) {
            objc_setAssociatedObject(self, &borderWith_Key, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    var borderColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &borderColor_Key) as! UIColor
        }
        set(newValue) {
            objc_setAssociatedObject(self, &borderColor_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.leftborder?.fillColor = newValue.cgColor
            self.rightborder.fillColor = newValue.cgColor
            self.topborder.fillColor = newValue.cgColor
            self.bottomborder.fillColor = newValue.cgColor
        }
    }
    var leftborderColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &leftBorderCorlor_Key) as! UIColor
        }
        set(newValue) {
            objc_setAssociatedObject(self, &leftBorderCorlor_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.leftborder?.fillColor = newValue.cgColor
        }
    }
    var rightborderColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &rightBorderCorlor_Key) as! UIColor
        }
        set(newValue) {
            objc_setAssociatedObject(self, &rightBorderCorlor_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.rightborder.fillColor = newValue.cgColor
        }
    }
    
    var topborderColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &topBorderCorlor_Key) as! UIColor
        }
        set(newValue) {
            objc_setAssociatedObject(self, &topBorderCorlor_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.topborder.fillColor = newValue.cgColor
        }
    }
    
    var bottomborderColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &bottomBorderCorlor_Key) as! UIColor
        }
        set(newValue) {
            objc_setAssociatedObject(self, &bottomBorderCorlor_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.bottomborder.fillColor = newValue.cgColor
        }
    }
    
   private var leftborder: CAShapeLayer? {
        get {
            return objc_getAssociatedObject(self, &leftBorder_Key) as? CAShapeLayer
        }
        set(newValue) {
            objc_setAssociatedObject(self, &leftBorder_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private var rightborder: CAShapeLayer {
        get {
            return objc_getAssociatedObject(self, &rightBorder_Key) as! CAShapeLayer
        }
        set(newValue) {
            objc_setAssociatedObject(self, &rightBorder_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var topborder: CAShapeLayer {
        get {
            return objc_getAssociatedObject(self, &topBorder_Key) as! CAShapeLayer
        }
        set(newValue) {
            objc_setAssociatedObject(self, &topBorder_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var bottomborder: CAShapeLayer {
        get {
            return objc_getAssociatedObject(self, &bottomBorder_Key) as! CAShapeLayer
        }
        set(newValue) {
            objc_setAssociatedObject(self, &bottomBorder_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func drawPath(rect:CGRect,color:UIColor) -> CAShapeLayer {
        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = color.cgColor
        self.layer.addSublayer(lineShape)
        return lineShape
    }

    public func drawBorder(positions:Array<BorderPosition>,borderColor:UIColor){
        
        positions.forEach{ (position) in
            switch position {
            case .left :
                leftBorder(borderColor: borderColor)
            case .right :
                rightBorder(borderColor: borderColor)
            case .top :
                topBorder(borderColor: borderColor)
            case .bottom :
                buttomBorder(borderColor: borderColor)
            }
        }
    }
    
    //设置右边框
    public func rightBorder(borderColor:UIColor){
        let rect = CGRect(x: self.frame.size.width - borderWith, y: 0, width: borderWith, height: self.frame.size.height)
       self.rightborder = drawPath(rect: rect, color: borderColor)
    }
    //设置左边框
    public func leftBorder(borderColor:UIColor){
        let rect = CGRect(x: 0, y: 0, width: borderWith, height: self.frame.size.height)
        self.leftborder = drawPath(rect: rect, color: borderColor)
    }

    //设置上边框
    public func topBorder(borderColor:UIColor){
        let rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: borderWith)
        self.topborder = drawPath(rect: rect, color: borderColor)
    }


    //设置底边框
    public func buttomBorder(borderColor:UIColor){
        let rect = CGRect(x: 0, y: self.frame.size.height-borderWith, width: self.frame.size.width, height: borderWith)
        self.bottomborder = drawPath(rect: rect, color: borderColor)
    }

}
