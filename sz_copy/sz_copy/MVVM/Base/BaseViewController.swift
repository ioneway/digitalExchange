//
//  ViewController.swift
//  RxSwiftMVVM
//
//  Created by 王健伟 on 2017/10/30.
//  Copyright © 2017年 JianweiWang. All rights reserved.
//

import UIKit
import RxSwift
// There is not Generic modify at instance of StoryBoard, so ViewController havn't Generic
// Consider use associatedtype instead in future, then remove Router Module, Remove ObjC Runtime and Reflecte, turn Swift back Static
class BaseViewController<T: BaseViewModel>: UIViewController, ViewProtocol{
    let disposeBag = DisposeBag()
    var _viewModel: T?
    
    var viewModel: T? {
        get {
            return self._viewModel
        }
        set {
            assert(self.viewModel == nil, "only call once in Router With installViewModel, reset viewModel is NOT ALLLOWED, the viewModel MUST to be READONLY")
            self._viewModel = newValue
        }
    }
    
    func bindViewModel() {}
    
    func setupUI() {}
    
    func configConstraints() {}
    
    func installViewModel(_ viewModel: ViewModelProtocol) {
        self.viewModel = (viewModel as! T)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.setupUI()
        self.configConstraints()
        self.bindViewModel()
    }
}


