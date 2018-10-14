//
//  Notifications.swift
//  Exchange
//
//  Created by rui on 2018/4/20.
//  Copyright © 2018年 common. All rights reserved.
//

import Foundation

extension Notification.Name {
    public struct Theme {
        public static let ThemeNeedChange = Notification.Name(rawValue: "com.common.exchange.themeNeedChange")
    }
    
    public struct Exchange {
        public static let HomePageScroll = Notification.Name(rawValue: "com.common.exchange.homePageScroll")
        public static let RefreshBanner = Notification.Name(rawValue: "com.common.exchange.refreshBanner")
        public static let loginDidChange = Notification.Name(rawValue: "com.common.exchange.loginDidChange")
        public static let adverDidChange = Notification.Name(rawValue: "com.common.exchange.adverDidChange")
        public static let assetDidChange = Notification.Name(rawValue: "com.common.exchange.assetDidChange")
        public static let securityDidChange = Notification.Name(rawValue: "com.common.exchange.securityDidChange")
        ///广告列表信息需要刷新
        public static let adListNeedRefresh = Notification.Name(rawValue: "com.common.exchange.adListNeedRefresh")
        ///广告列表刷新需要刷新的头部未读消息
        public static let chatNeedRefresh = Notification.Name(rawValue: "com.common.exchange.chatNeedRefresh")
        ///法币订单里边需要刷新未读消息
        public static let chatNeedRefresh2 = Notification.Name(rawValue: "com.common.exchange.chatNeedRefresh2")
        public static let addressChange = Notification.Name(rawValue: "com.common.exchange.addressChange")
        public static let addressNumberChange = Notification.Name(rawValue: "com.common.exchange.addressNumberChange")
        public static let addressDidSelect = Notification.Name(rawValue: "com.common.exchange.addressDidSelec")
        public static let primarycertification = Notification.Name(rawValue: "com.common.exchange.primarycertification")
    }
}
