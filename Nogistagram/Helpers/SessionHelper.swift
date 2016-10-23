//
//  SessionHelper.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/17.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import Foundation
import KeychainAccess

class SessionHelper {
    static func authDict() -> [String: String]? {
        let keychain = Keychain(service: Constant.Keychain.service)
        do {
            let uid: String = try keychain.get("uid")!
            let client: String = try keychain.get("clientId")!
            let accessToken: String = try keychain.get("accessToken")!
            let authDict: [String: String] = [
                "Access-Token": accessToken,
                "Uid": uid,
                "Client": client,
                ]
            return authDict
        } catch let error {
            print(error)
            return nil
        }
    }
    
    static func currentUser() -> User? {
        return Session.all().first
    }
}
