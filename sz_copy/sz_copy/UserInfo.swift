//
//  AppInfo.swift
//  Exchange
//
//  Created by rui on 2018/6/5.
//  Copyright © 2018年 common. All rights reserved.
//

import UIKit
import SwiftyUserDefaults


extension DefaultsKeys {
    static let userInfoKey = DefaultsKey<UserInfo?>("userInfoKey")
}

final class UserInfo: Codable, DefaultsSerializable {
    
    var nickName: String?
    var loginName: String?
    var email: String?
    var token: String? 
    var mobile: String?
    var portrait: String?
    var userId: Int?
    var reviews: String?
    var trustNum: Int?
    var expirationDate:Int64?
    var account:String?
    var currency:String = "CNY" //当前法币符号 默认CNY
    var language:String = "zh-Hans"  //当前语言 默认"zh-Hans"

    var isEnglish: Bool {
        get {
            if language.contains("en") {
                return true
            }else {
                return false
            }
        }
    }
    
    var isLogin: Bool{
        get {
            if let token = token, !token.isEmpty {
                return true
            }else {
                return false
            }
        }
    }
    
    static let `default`: UserInfo = UserInfo()
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(write), name: .UIApplicationDidEnterBackground, object: nil)
        guard let obj = Defaults[.userInfoKey] else { return }
        
        self.loginName = obj.loginName
        self.nickName = obj.nickName
        self.email = obj.email
        self.token = obj.token
        self.mobile = obj.mobile
        self.portrait = obj.portrait
        self.userId = obj.userId
        self.reviews = obj.reviews
        self.trustNum = obj.trustNum
        self.expirationDate = obj.expirationDate
        self.account = obj.account
        self.currency = obj.currency
        self.language = obj.language
    }
    
    func install(data: [String:Any]) {
        if let loginName = data["loginName"] as? String {
            self.loginName = loginName
        }
        if let email = data["email"] as? String {
            self.email = email
        }
        if let token = data["token"] as? String {
            self.token = token
        }
        if let nickName = data["nickName"] as? String {
            self.nickName = nickName
        }
        if let portrait = data["portrait"] as? String {
            self.portrait = portrait
        }
        if let userId = data["userId"] as? Int {
            self.userId = userId
        }
        if let trustNum = data["trustNum"] as? Int {
            self.trustNum = trustNum
        }
        if let reviews = data["reviews"] as? String {
            self.reviews = reviews
        }
        if let expirationDate = data["expirationDate"] as? Int64 {
            self.expirationDate = expirationDate
        }

        write()
    }
    
    @objc func write() { //写入数据
        Defaults[.userInfoKey] = self
    }
    
    private func changeLoginState() {
        if !self.isLogin {
            self.token = nil
            self.nickName = nil
            self.loginName = nil
            self.email = nil
            self.mobile = nil
            self.portrait = nil
            self.userId = nil
            self.reviews = nil
            self.trustNum = nil
            self.expirationDate = nil
            write()
//            AppSecurityInfo.default.model = SecurityModel()
//            AppSecurityInfo.default.openScreenLock(dic: [:])
        }
        NotificationCenter.default.post(name: NSNotification.Name.Exchange.loginDidChange, object: nil)
        NotificationCenter.default.post(name: NSNotification.Name.Exchange.adListNeedRefresh, object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

