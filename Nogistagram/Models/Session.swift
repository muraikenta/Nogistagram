//
//  Session.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/17.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import ObjectMapper

class Session: User {
    required convenience init?(map: Map) {
        self.init()
    }
}
