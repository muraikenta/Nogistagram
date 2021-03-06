//
//  AccountRegistrationViewController.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/07.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit

class AccountRegistrationViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    var userParams: [String : String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(userParams)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destinationController: UIViewController = segue.destination
        switch segue.identifier! {
        case "toUniqueNameRegistration":
            let uniqueNameRegistrationViewController = destinationController as! UniqueNameRegistrationViewController
            let userName = userNameField.text
            let password = passwordField.text
            userParams["name"] = userName!
            userParams["password"] = password!
            userParams["password_confirmation"] = password!
            uniqueNameRegistrationViewController.userParams = userParams
        default:
            break
        }
    }

}
