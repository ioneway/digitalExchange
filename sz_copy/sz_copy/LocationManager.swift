//
//  LocationManager.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/27.
//  Copyright © 2018年 王伟. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let `default`: LocationManager = LocationManager()
    
    private var manager = CLLocationManager()
    private var location = CLLocation.init()
    private(set) var address = ""
    
    func startLocation() {
        manager.delegate = self
        //定位方式
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if #available(iOS 8.0, *){
             //使用应用程序期间允许访问位置数据
             manager.requestWhenInUseAuthorization()
        }
        //开启定位
        manager.startUpdatingLocation()
    }
}
extension LocationManager: CLLocationManagerDelegate
{
    //获取定位信息
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //取得locations数组的最后一个
        location = locations.last!
        //判断是否为空
        if(location.horizontalAccuracy > 0){
            let lat = Double(String(format: "%.1f", location.coordinate.latitude))
            let long = Double(String(format: "%.1f", location.coordinate.longitude))
            log("纬度:\(long!)")
            log("经度:\(lat!)")
            
            LonLatToCity()
            //停止定位
            manager.stopUpdatingLocation()
        }
    }
    
    //出现错误
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print(error ?? "定位失败")
    }
    
    ///将经纬度转换为城市名
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemark, error) -> Void in
            
            if(error == nil)
            {
                let array = placemark!
                guard let mark = array.first else { return }
                let city: String = mark.locality ?? ""                  //城市
                let country: String = mark.country ?? ""                //国家
                let CountryCode: String = mark.isoCountryCode ?? ""     //国家编码
                let SubLocality: String = mark.subLocality ?? ""        //区
                
                self.address = SubLocality+"_"+city+"_"+country+CountryCode //西湖区_杭州_中国CN
                log("定位位置：\(self.address)")
            }
            else
            {
                self.address = "定位失败"
                log(error?.localizedDescription)
            }
        }
    }
}
