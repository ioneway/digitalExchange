//
//  SettingViewModel
//  sz_copy
//
//  Created by 王伟 on 2018/10/19.
//  Copyright © 2018年 王伟. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa
import Action
import Moya
import Moya_ObjectMapper
import ObjectMapper

class SettingViewModel: BaseViewModel {
    
    
    override init() {
        super.init(vcName: MineViewController.wholeClassName)
    }
    
    override func initialize() {
        
    }
}

