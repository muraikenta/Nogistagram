//
//  hoge.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/14.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}
