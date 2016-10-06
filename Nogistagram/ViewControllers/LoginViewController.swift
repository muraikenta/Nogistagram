//
//  LoginViewController.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/03.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import SnapKit

class LoginViewController: UIViewController, LoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-60)
            make.centerX.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        let connection = GraphRequestConnection()
        connection.add(
            GraphRequest(graphPath: "me?fields=id,name,email"),
            batchParameters: nil,
            completion: { (error, result) in
                print(result)
            }
        )
        connection.start()
        
        if let accessToken = AccessToken.current {
            print(accessToken)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
