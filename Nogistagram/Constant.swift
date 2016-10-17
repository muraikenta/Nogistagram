//
//  File.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/09.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import Foundation

struct Constant {
    struct Api {
        static let host = "http://localhost:3002"
        static let root = Constant.Api.host + "/api"
    }
    
    struct Keychain {
        static let service: String = Bundle.main.bundleIdentifier!
    }
}
