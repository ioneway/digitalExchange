//
//  UITableView+Extension.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/10.
//  Copyright © 2018 王伟. All rights reserved.
//

import Foundation
import UIKit

public struct ReusableIdentifier <T: UIView> {
    let identifier: String
    
    init() {
        identifier = T.identifier
    }
}

extension UITableView {
    
    func registerClass<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: ReusableIdentifier<T>().identifier)
    }
    
    func registerNib<T: UITableViewCell>(_: T.Type) {
        let nib = UINib.init(nibName: ReusableIdentifier<T>().identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: ReusableIdentifier<T>().identifier)
    }
    
    
    func dequeue<T: UITableViewCell>(indexPath: IndexPath) -> T {
        let rid = ReusableIdentifier<T>()
        guard let cell = dequeueReusableCell(withIdentifier: rid.identifier, for: indexPath) as? T else {
            assertionFailure("No identifier(\(rid.identifier)) found for \(T.self)")
            return T.init()
        }
        return cell
    }
}

