//
//  File.swift
//  RxSwiftMVVM
//
//  Created by 王健伟 on 2017/10/30.
//  Copyright © 2017年 JianweiWang. All rights reserved.
//

import Foundation
import NSObject_Rx
import Moya
import RxSwift

class BaseViewModel {
    let disposeBag = DisposeBag()
    let model: Model
    var params: [Any?] = []
    private let _vcName: String
    private let _service: ViewModelService

    var vcName: String {
        return self._vcName
    }
    
    init () {
        _vcName = "vc"
        _service = Service.instance
        model = _service.model
        self.initialize()
    }
    init(vcName: String) {
        _vcName = vcName
        _service = Service.instance
        model = _service.model
        self.initialize()
    }
    
    func initialize() {
        
    }
    
    
    func param(_ param: Any) -> BaseViewModel {
        self.params.append(param)
        return self
    }
}

extension BaseViewModel: ViewModelProtocol {
    
    var service: ViewModelService {
        return _service
    }
    func push(_ animated: Bool = true) {
        self.service.pushViewModel(self, animated)
    }
    func pop(_ animated: Bool = true) {
        self.service.popViewModel(animated)
    }
    func present(_ animated: Bool = true, _ completion: (() -> Void)? = nil) {
        self.service.presentViewModel(self, animated, completion)
    }
    func dismiss(_ animated: Bool = true,  _ completion: (() -> Void)? = nil) {
        self.service.dismissViewModel(animated, completion)
    }
}
