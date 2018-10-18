//
//  SliderValue.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/18.
//  Copyright © 2018 王伟. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SliderValue<Base: SliderView> {
    /// Base text input to extend.
    public let base: Base
    
    /// Reactive wrapper for `text` property.
    public let value: ControlProperty<Double?>
    
    /// Initializes new text input.
    ///
    /// - parameter base: Base object.
    /// - parameter text: Textual control property.
    public init(base: Base, value: ControlProperty<Double?>) {
        self.base = base
        self.value = value
    }
}

