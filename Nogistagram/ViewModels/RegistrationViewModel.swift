//
//  RegistrationViewModel.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/09.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RegistrationViewModel {
    let email = Variable("")
    let enableGoToNextButton: Observable<Bool>
    
    init() {
        enableGoToNextButton = email.asObservable().map{
            $0.characters.count > 0
        }
    }

    func goToNext() {
        print("email=", email.value)
        email.value = ""
    }

    // TODO: こんなの使って次へボタンが押されたときにエラーメッセージ出す
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return Regexp(emailRegEx).isMatch(input: email)
    }
}
