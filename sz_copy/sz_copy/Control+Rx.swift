//
//  Control+Rx.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/26.
//  Copyright © 2018年 王伟. All rights reserved.
//

/*
 *自定义或者第三方组件添加可绑定属性
 */


import Foundation
import SDCycleScrollView
import RxCocoa
import RxSwift

extension SDCycleScrollView {
    public var rxlocalizationImageNamesGroup: Binder<[String]> {
        return Binder(self) { view, group in
            view.localizationImageNamesGroup = group
        }
    }
}
//
//extension Reactive where Base: SDCycleScrollView {
//    /// Reactive wrapper for `date` property.
//    public var rxlocalizationImageNamesGroup: Binder<[String]> {
//        return Binder(self.base) { view, group in
//            view.localizationImageNamesGroup = group
//        }
//    }
//}
