//
//  DataModel.swift
//  sz_copy
//
//  Created by 王伟 on 2017/10/31.
//  Copyright © 2017年 weiWang. All rights reserved.
//

import UIKit
import ObjectMapper

class DataModel : Mappable {
    
    var status: Int?
    var timestamp: Int?
    var data: [AllCoinDetailModel]?
    
    required init?(map: Map) {}
    
    init() {}
    
    func mapping(map: Map)
    {
        status <- map["status"]
        timestamp <- map["timestamp"]
        data <- map["data"]
    }
}
