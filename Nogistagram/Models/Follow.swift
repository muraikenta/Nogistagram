//
//  Post.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/18.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Follow: Object, Mappable {
    dynamic var id: Int = 0
    dynamic var fromUserId: Int = 0
    dynamic var toUserId: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.fromUserId <- map["fromUserId"]
        self.toUserId <- map["toUserId"]
    }
}
