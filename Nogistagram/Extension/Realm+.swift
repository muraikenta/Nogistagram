//
//  Realm+.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/23.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmType {}
extension Object: RealmType {}
extension Array: RealmType {}


private func realmBlock(block: (Realm) throws -> Void) -> Bool {
    do {
        try block(try Realm())
        return true
    } catch {
        print(error)
    }
    return false
}

// MARK:- Write
extension RealmType where Self: Object {
    
    func write(block: (Realm) -> Void) -> Bool {
        return realmBlock { realm in
            try realm.write {
                block(realm)
            }
        }
    }
    
    func save() -> Bool {
        return write { realm in
            realm.add(self, update: true)
        }
    }
    
    func saveAsync() {
        DispatchQueue(label: "realm-background").async {
            self.save()
        }
    }
}

extension Array where Element: Object {
    
    func write(block: (Realm) -> Void) -> Bool {
        return realmBlock { realm in
            try realm.write {
                block(realm)
            }
        }
    }
    
    func save() -> Bool {
        return write { realm in
            realm.add(self, update: true)
        }
    }
    
    func saveAsync() {
        DispatchQueue(label: "realm-background").async {
            self.save()
        }
    }
}


// MARK:- Read
extension RealmType where Self: Object {
    
    static func all() -> [Self] {
        if let realm = try? Realm() {
            return Array(realm.objects(Self.self))
        }
        return []
    }
    
    static func findAll(predicateFormat: String, _ args: AnyObject...) -> [Self] {
        if let realm = try? Realm() {
            return Array(realm.objects(Self.self).filter(predicateFormat, args))
        }
        return []
    }
    
    static func find(_ id: Int) -> Self? {
        if let realm = try? Realm() {
            return realm.objects(Self.self).filter("id == \(id)").first
        }
        return nil
    }
}


// MARK:- Delete
extension RealmType where Self: Object {
    static func deleteAll(predicateFormat: String, _ args: AnyObject...) -> Bool {
        return realmBlock { realm in
            let results = realm.objects(Self.self).filter(predicateFormat, args)
            
            try realm.write {
                realm.delete(results)
            }
        }
    }
    
    static func deleteAll() -> Bool {
        return realmBlock { realm in
            try realm.write {
                realm.delete(self.all())
            }
        }
    }
    
    func delete() -> Bool {
        return write { realm in
            realm.delete(self)
        }
    }
}

extension Array where Element: Object {
    func delete() -> Bool {
        return write { realm in
            realm.delete(self)
        }
    }
}
