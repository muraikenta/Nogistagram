//
//  FacebookLoginable.swift
//  Nogistagram
//
//  Created by 村井謙太 on 2016/10/09.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import SnapKit

protocol FacebookLoginable: LoginButtonDelegate {
    var userParams: [String: String] { get set }
    func addFacebookLoginButton()
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult)
    func loginButtonDidLogOut(_ loginButton: LoginButton)
    func graphRequest()
    func graphRequestDidComplete(userParams: [String: String])
    func performSegueAfterLogin(userParams: [String: String])
}

extension FacebookLoginable where Self: UIViewController {
    func addFacebookLoginButton() {
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-60)
            make.centerX.equalToSuperview()
        }
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .success(_, _, _):
            graphRequest()
        case .cancelled:
            print("Canceled!!!!!!!!!!")
        case .failed(let error):
            print(error)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
    }
    
    func graphRequest() {
        let connection = GraphRequestConnection()
        connection.add(
            GraphRequest(graphPath: "me?fields=id,name,email"),
            batchParameters: nil,
            completion: { (error: HTTPURLResponse?, graphResult: GraphRequestResult<GraphRequest>) in
                print(graphResult)
                switch graphResult {
                case .success(let response):
                    let userParams: [String: String] = [
                        "name": response.dictionaryValue!["name"] as! String,
                        "email": response.dictionaryValue!["email"] as! String,
                        "uid": response.dictionaryValue!["id"] as! String,
                        "provider": "facebook",
                        "omniauth_token": AccessToken.current!.authenticationToken,
                    ]
                    
                    self.graphRequestDidComplete(userParams: userParams)
                    
                case .failed(let error):
                    print(error)
                }
            }
        )
        connection.start()
    }
    
    func performSegueAfterLogin(userParams: [String: String]) {
        if AccessToken.current != nil {
            self.performSegue(withIdentifier: "toUniqueNameRegistration", sender: userParams)
        }
    }
}
