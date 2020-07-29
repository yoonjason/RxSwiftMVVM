//
//  LoginModel.swift
//  RxSwiftMVVMLogin
//
//  Created by yoon on 2020/07/29.
//  Copyright © 2020 yeongseok. All rights reserved.
//

import Foundation
import RxSwift

struct LoginModel {
    
    func requestLogin(id: String, pw : String) -> Observable<Result<User, LoginError>> {
        return Observable.create{ (observer) -> Disposable in
            
            if id != "" && pw != "" {
                observer.onNext(.success(User(name: id, password: pw)))
            }else {
                observer.onNext(.failure(.defaultError))
            }
                
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
