//
//  LoginViewModel.swift
//  Nogistagram
//
//  Created by suzukisho on 2016/10/10.
//  Copyright © 2016年 村井謙太. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    let name = Variable("")
    let password = Variable("")
    let enableLoginButton: Observable<Bool>
    
    init() {
        enableLoginButton = Observable.combineLatest(name.asObservable(), password.asObservable()) {
            $0.0.characters.count > 0 && $0.1.characters.count > 0
        }
    }
    
    func login() {
        print("name=", name.value)
        print("password=", password.value)
        name.value = ""
        password.value = ""
    }
}
