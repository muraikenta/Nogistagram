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
import Alamofire

class LoginViewController: UIViewController, LoginButtonDelegate {

    var userParams = [String: String]()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if AccessToken.current != nil {
            self.performSegue(withIdentifier: "toUniqueNameRegistration", sender: userParams)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func graphRequest() {
        let connection = GraphRequestConnection()
        connection.add(
            GraphRequest(graphPath: "me?fields=id,name,email"),
            batchParameters: nil,
            completion: { (error: HTTPURLResponse?, graphResult: GraphRequestResult<GraphRequest>) in
                print(graphResult)
                switch graphResult {
                case .success(let response):
                    // TODO: Userモデルに入れる
                    self.userParams = [
                        "name": response.dictionaryValue!["name"] as! String,
                        "email": response.dictionaryValue!["email"] as! String,
                        "uid": response.dictionaryValue!["id"] as! String,
                        "provider": "facebook",
                        "omniauth_token": AccessToken.current!.authenticationToken,
                    ]
                    
                    // TODO: emailのバリデーション
                    
                case .failed(let error):
                    print(error)
                }
            }
        )
        connection.start()
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
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
            uniqueNameRegistrationViewController.userParams = sender as! [String : String]
        default:
            break
        }
    }

}
