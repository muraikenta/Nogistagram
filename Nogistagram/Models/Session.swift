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
    dynamic var userId: Int = 0
    dynamic var name: String!
    dynamic var uniqueName: String!
    dynamic var email: String!
    dynamic var introduction: String!
    dynamic var website: String!
    dynamic var gender: Int = 0
    dynamic var imageUrl: String!
    dynamic var privacyType: Int = 0
    

    required convenience init?(map: Map) {
        self.init()
        // self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        userId <- map["user_id"]
        name <- map["name"]
        uniqueName <- map["unique_name"]
        email <- map["email"]
        introduction <- map["introduction"]
        website <- map["website"]
        gender <- map["gender"]
        imageUrl <- map["image_url"]
        privacyType <- map["privacy_type"]
    }
}
