//
//  UniqueNameRegistrationViewController.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/07.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

class UniqueNameRegistrationViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var uniqueNameField: UITextField!

    var userParams: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(userParams)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Actions
    @IBAction func register(_ sender: UIButton) {
        userParams["unique_name"] = uniqueNameField.text!
        if (userParams["uid"] != nil) {
            // facebooklogin
            Alamofire
                .request("\(Constant.Api.root)/omniauth", method: .post, parameters: userParams)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let headers = response.response!.allHeaderFields
                        let accessToken: String = headers["Access-Token"]! as! String
                        let uid: String = headers["Uid"]! as! String
                        let clientId: String = headers["Client"]! as! String

                        let keychain = Keychain(service: Constant.Keychain.service)

                        // TODO: sessionモデルにユーザー情報保存
                        do {
                            try keychain.set(accessToken, key: "accessToken")
                            try keychain.set(uid, key: "uid")
                            try keychain.set(clientId, key: "clientId")
                            
                            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController")
                            self.present(tabBarController, animated: true, completion: nil)
                        } catch let error {
                            print(error)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
        } else {
            Alamofire
                .request("\(Constant.Api.root)/auth", method: .post, parameters: userParams)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let headers = response.response!.allHeaderFields
                        let accessToken: String = headers["Access-Token"]! as! String
                        let uid: String = headers["Uid"]! as! String
                        let clientId: String = headers["Client"]! as! String

                        let keychain = Keychain(service: Constant.Keychain.service)
                        do {
                            try keychain.set(accessToken, key: "accessToken")
                            try keychain.set(uid, key: "uid")
                            try keychain.set(clientId, key: "clientId")
                            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController")
                            self.present(tabBarController, animated: true, completion: nil)
                        } catch let error {
                            print(error)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }

}
