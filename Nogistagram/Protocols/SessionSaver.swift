//
//  SessionSaver.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/23.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper
import KeychainAccess

protocol SessionSaver {
    func saveSession(_ response: DataResponse<Any>)
}

extension SessionSaver where Self: UIViewController {
    func saveSession(_ response: DataResponse<Any>) {
        let headers = response.response!.allHeaderFields
        saveAuthData(headers)
        
        let json = JSON(response.result.value)
        print(json)
        let session = Mapper<Session>().map(JSON: json["data"].dictionaryObject!)!
        session.save()
    }
    
    func saveAuthData(_ headers: [AnyHashable: Any]) {
        let accessToken: String = headers["Access-Token"]! as! String
        let uid: String = headers["Uid"]! as! String
        let clientId: String = headers["Client"]! as! String

        let keychain = Keychain(service: Constant.Keychain.service)
        do {
            try keychain.set(accessToken, key: "accessToken")
            try keychain.set(uid, key: "uid")
            try keychain.set(clientId, key: "clientId")
            
        } catch let error {
            print(error)
        }
    }
    
}
