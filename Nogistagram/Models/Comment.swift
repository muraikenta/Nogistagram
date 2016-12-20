//
//  Comment.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/11/03.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Comment: Object, Mappable {
    dynamic var id: Int = 0
    dynamic var body = ""
    dynamic var createdAt: Date?
    
    let users = LinkingObjects(fromType: User.self, property: "comments")
    dynamic var user: User? {
        return self.users.first
    }
    
    let posts = LinkingObjects(fromType: Post.self, property: "comments")
    dynamic var post: Post? {
        return self.posts.first
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        body <- map["body"]
        
        if let createdAtString = map["created_at"].currentValue as? String {
            createdAt = DateHelper.date(fromString: createdAtString, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        }
    }
}
