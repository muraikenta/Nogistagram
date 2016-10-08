//
//  RegistrationViewController.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/06.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var emailField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        if segue.identifier == "toAccountRegistration" {
            let accountRegistrationViewController = segue.destination as! AccountRegistrationViewController
            let email = emailField.text
            let userParams: [String: String] = ["email": email!]
            accountRegistrationViewController.userParams = userParams
        }
    }

}
