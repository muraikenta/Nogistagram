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

class LoginViewController: UIViewController, FacebookLoginable {

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
    }

}
