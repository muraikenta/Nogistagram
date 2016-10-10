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
        // 3文字以上だったらボタンをenbaleにする
        
        enableGoToNextButton = Observable.combineLatest(email.asObservable(), email.asObservable()) {
            $0.0.characters.count >= 3 && $0.1.characters.count >= 3
        }
    }
    
    func goToNext() {
        print("email=", email.value)
        email.value = ""
    }
}
