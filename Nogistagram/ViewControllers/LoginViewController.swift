//
//  LoginViewController.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/03.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class LoginViewController: UIViewController, FacebookLoginable, SessionSaver {

    // MARK: Properties
    var userParams: [String: String] = [:]
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBindings()
        addFacebookLoginButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tryToSignIn(userParams: userParams)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func graphRequestDidComplete(userParams: [String: String]) {
        self.userParams = userParams
    }
    
    private func addBindings() {
        // name
        // UITextField -> ViewModel
        nameField.rx.textInput.text
            .bindTo(viewModel.name)
            .addDisposableTo(disposeBag)
        // ViewModel -> UITextField
        viewModel.name.asObservable()
            .observeOn(MainScheduler.instance)
            .bindTo(nameField.rx.textInput.text)
            .addDisposableTo(disposeBag)
        
        // password
        // UITextField -> ViewModel
        passwordField.rx.textInput.text
            .bindTo(viewModel.password)
            .addDisposableTo(disposeBag)
        // ViewModel -> UITextField
        viewModel.password.asObservable()
            .observeOn(MainScheduler.instance)
            .bindTo(passwordField.rx.textInput.text)
            .addDisposableTo(disposeBag)
        
        // UIButtonのタップイベント
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.login()
            })
            .addDisposableTo(disposeBag)
        // ViewModel -> UIButtonのenabled
        viewModel.enableLoginButton
            .bindTo(loginButton.rx.enabled)
            .addDisposableTo(disposeBag)
        // UIButtonの背景色をenableLoginButtonの状態によって変える
        viewModel.enableLoginButton
            .bindNext { [weak self] valid in
                self?.loginButton.backgroundColor = valid ? UIColor(red: 0/255, green: 151/255, blue: 255/255, alpha: 1) : UIColor(red: 150/255, green: 213/255, blue: 255/255, alpha: 1.0)
        }
        .addDisposableTo(disposeBag)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        let destinationController: UIViewController = segue.destination
        switch identifier {
        case "toUniqueNameRegistration":
            let uniqueNameRegistrationViewController = destinationController as! UniqueNameRegistrationViewController
            uniqueNameRegistrationViewController.userParams = sender as! [String : String]
        default:
            break
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        let name = nameField.text!
        let password = passwordField.text!
        // 本物はunique_nameでもemailでもログインできるがとりあえずemailだけ
        userParams["email"] = name
        userParams["password"] = password
        Alamofire
            .request("\(Constant.Api.root)/auth/sign_in", method: .post, parameters: userParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    self.saveSession(response)
                    
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController")
                    self.present(tabBarController, animated: true, completion: nil)
                case .failure(let error):
                    let failAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                    failAlert.title = "メールアドレスもしくはパスワードが正しくありません"
                    failAlert.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: .cancel,
                            handler: nil
                        )
                    )
                    self.present(
                        failAlert,
                        animated: true,
                        completion: {
                            print(error)
                        }
                    )
                }
        }
    }
    

}
