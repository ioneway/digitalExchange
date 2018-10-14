//
//  Model.swift
//  RxSwiftMVVM
//
//  Created by 王健伟 on 2017/10/31.
//  Copyright © 2017年 JianweiWang. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper

final class Model {

    func request<T: Mappable>(_ type: API, _ model: T.Type) -> Single<T> {
        let ob = SZProvider.rx.request(type).mapObject(model)
        return ob
    }
}
