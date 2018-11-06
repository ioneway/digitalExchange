//
//  AppDelegate.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/10.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let `default`: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    var locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        log.info(" verbose message, usually useful when working on a specific problem")
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.isHidden = false
        window?.backgroundColor = ColorAsset.BackGround.Level4.color
        NavigationControllerStack.initialize()
        Service.instance.resetRootViewModel(TabBarViewModel())
        
        //开启定位，获取位置
//        LocationManager.default.startLocation()
        TickServer.default.subscriptTick(pairs: ["ETH_BTC"])
        TickServer.default.dicVariable.asObservable().bind{ result in
            log(result["ETH_BTC"])
        }
        //socket服务订阅
//        SocketManager.shared.subscribe(server: ServerExTick())      ////数字货币兑换法币的汇率
//        SocketManager.shared.subscribe(server: ServerExTicBTC())    ////数字货币兑换BTC的汇率
//      SocketManager.shared.subscribe(server: ServerTick())        ////行情
        
        UserInfo.default.language = .english
        UserInfo.default.token = "ffd"
        
        SZProvider.request(.AllTradeInfo) { result in
            switch result {
            case let .success(response):
                print(response)
                break
            case let .failure(error):
                 print(error)
                break
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {
//        let datas = APPTransactionPair.default.exTickDatas
//                log(datas!["BTC"])
//        let datas = APPTransactionPair.default.exTickDatas
        
//        log(datas!["SZ"])
    }

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}


}





