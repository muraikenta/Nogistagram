//
//  RealmHelper.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/23.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    // マイグレーションが必要なときに、以下でDBを削除すると楽
    static func purge() {
        do {
            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
            print("purged realm")
        } catch {
            print(error)
        }
    }
}
