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
    
    dynamic var imageUrl =  ""
    dynamic var body = ""
    
    required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        imageUrl <- map["image_url"]
        body <- map["body"]
        
    }
}
