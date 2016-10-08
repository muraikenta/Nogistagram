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

    var userParams = [String: String]()

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
        let uniqueName = uniqueNameField.text
        userParams["unique_name"] = uniqueName!
        if (userParams["uid"] != nil) {
            // facebooklogin
        } else {
            Alamofire
                .request("http://localhost:3002/api/auth", method: .post, parameters: userParams)
                .responseJSON { response in
                    if response.response!.statusCode == 200 {
                        let headers = response.response!.allHeaderFields
                        let accessToken: String = headers["Access-Token"]! as! String
                        let uid: String = headers["Uid"]! as! String
                        let clientId: String = headers["Client"]! as! String

                        // MEMO: うまくいってないかも。使うときに確かめる
                        let keychain = Keychain(service: "com.nogistagram")
                        keychain["accessToken"] = accessToken
                        keychain["uid"] = uid
                        keychain["clientId"] = clientId

                        // TODO: 画面遷移
                    } else {
                        print("ERROR!!!!")
                    }
                }
        }
    }

}
