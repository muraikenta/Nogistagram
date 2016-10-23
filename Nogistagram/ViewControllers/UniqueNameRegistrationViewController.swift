//
//  UniqueNameRegistrationViewController.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/07.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Alamofire

class UniqueNameRegistrationViewController: UIViewController, SessionSaver {
    
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
    
    // MARK: Actions
    @IBAction func register(_ sender: UIButton) {
        userParams["unique_name"] = uniqueNameField.text!
        let apiPath = userParams["uid"] == nil ? "auth" : "omniauth"
        
        Alamofire
            .request("\(Constant.Api.root)/\(apiPath)", method: .post, parameters: userParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    self.saveSession(response)
                        
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController")
                    self.present(tabBarController, animated: true, completion: nil)
                case .failure(let error):
                    print(error)
                }
            }
    }

}
