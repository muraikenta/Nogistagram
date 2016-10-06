//
//  RegistrationViewController.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/06.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let parameters: [String: String] = [
            "email": emailField.text ?? "",
            "password": passwordField.text ?? "",
            "password_confirmation": passwordField.text ?? "",
        ]
        Alamofire
            .request("http://localhost:3002/api/auth", method: .post, parameters: parameters)
            .responseJSON { response in
                print(response)
            }
    }

}
