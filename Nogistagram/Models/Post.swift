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

class Post: Object, Mappable {
    dynamic var id: Int = 0
    dynamic var user: User?
    dynamic var imageUrl =  ""
    dynamic var body = ""
    dynamic var createdAt: Date?
    dynamic var isLiked: Bool = false
    var comments = List<Comment>()

    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user <- map["user"]
        imageUrl <- map["image_url"]
        body <- map["body"]
        isLiked <- map["is_liked"]
        
        if let createdAtString = map["created_at"].currentValue as? String {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            createdAt = formatter.date(from: createdAtString)
        }
    }
    
    static func all() -> [Post] {
        let realm = try! Realm()
        return Array(realm.objects(Post.self).sorted(byProperty: "createdAt", ascending: false))
    }
}
