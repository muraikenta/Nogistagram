//
//  RegistrationViewController.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/06.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegistrationViewController: UIViewController, FacebookLoginable {

    // MARK: Properties
    var userParams: [String: String] = [:]
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nextButton: UIButton!

    private let viewModel = RegistrationViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController: UIViewController = segue.destination
        switch segue.identifier! {
        case "toUniqueNameRegistration":
            let uniqueNameRegistrationViewController = destinationController as! UniqueNameRegistrationViewController
            uniqueNameRegistrationViewController.userParams = sender as! [String : String]
        case "toAccountRegistration":
            let email: String = emailField.text!
            if self.isValidEmail(email) {
                userParams = ["email": email]
                let accountRegistrationViewController = destinationController as! AccountRegistrationViewController
                accountRegistrationViewController.userParams = userParams
            } else {
                // TODO: UIに反映
                print("有効なメールアドレスを入力してください")
            }
        default:
            break
        }

    }
    
    private func addBindings() {
        // email
        // UITextField -> ViewModel
        emailField.rx.textInput.text
            .bindTo(viewModel.email)
            .addDisposableTo(disposeBag)
        // ViewModel -> UITextField
        viewModel.email.asObservable()
            .observeOn(MainScheduler.instance)
            .bindTo(emailField.rx.textInput.text)
            .addDisposableTo(disposeBag)
        
        // UIButtonのタップイベント
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.goToNext()
            })
            .addDisposableTo(disposeBag)
        // ViewModel -> UIButtonのenabled
        viewModel.enableGoToNextButton
            .bindTo(nextButton.rx.enabled)
            .addDisposableTo(disposeBag)
    }
    
    // TODO: ViewModelに移す？
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return Regexp(emailRegEx).isMatch(email)
    }

}
