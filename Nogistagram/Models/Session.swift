//
//  Session.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/17.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Session: Object, Mappable {
    dynamic var user_id: Int = 0
    dynamic var name: String!
    dynamic var unique_name: String!
    dynamic var email: String!
    dynamic var introduction: String!
    dynamic var website: String!
    dynamic var gender: Int = 0
    dynamic var image_url: String!
    dynamic var privacy_type: Int = 0
    

    required convenience init?(map: Map) {
        self.init()
        // self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        name <- map["name"]
        unique_name <- map["unique_name"]
        email <- map["email"]
        introduction <- map["introduction"]
        website <- map["website"]
        gender <- map["gender"]
        image_url <- map["image_url"]
        privacy_type <- map["privacy_type"]
    }
}
