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

class RegistrationViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nextButton: UIButton!

    private let viewModel = RegistrationViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addBindings()
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
        case "toAccountRegistration":
            let email = emailField.text
            let userParams: [String: String] = ["email": email!]
            let accountRegistrationViewController = destinationController as! AccountRegistrationViewController
            accountRegistrationViewController.userParams = userParams
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

}
