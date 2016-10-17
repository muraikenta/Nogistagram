//
//  NibHelper.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/14.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit

protocol NibInstantiatable {}
extension UIView: NibInstantiatable {}

extension NibInstantiatable where Self: UIView {
    static func instantiate(withOwner ownerOrNil: Any? = nil) -> Self {
        let nib = UINib(nibName: self.className, bundle: nil)
        return nib.instantiate(withOwner: ownerOrNil, options: nil)[0] as! Self
    }
}
