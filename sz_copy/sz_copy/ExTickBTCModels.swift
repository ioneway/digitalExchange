//
//  ExTickModel.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/25.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import SwiftyUserDefaults

extension DefaultsKeys {
    static let exTickBTCModels = DefaultsKey<ExTickBTCModels?>("exTickBTCModels")
}

final class ExTickBTCModels: Mappable, Codable, DefaultsSerializable  {
    private(set) var cmd: String?
    private(set) var data: [String: Double]?
    private(set) var code: Int = -1
    
    required init?(map: Map) {
        NotificationCenter.default.addObserver(self, selector: #selector(write), name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    public init() {
        let models = Defaults[.exTickBTCModels]
        data = models?.data
        code = (models?.code)!
    }
    
    func mapping(map: Map)
    {
        cmd <- map["cmd"]
        data <- map["data"]
        code <- map["code"]
    }
    
    @objc private func write() { //写入数据
        Defaults[.exTickBTCModels] = self
    }
    
    subscript(coin: String) -> NSDecimalNumber?
    {
        get {
            let result = data?[coin]
            return "\(result ?? 0)".decimal
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


