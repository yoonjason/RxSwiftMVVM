//
//  ViewController.swift
//  RxSwiftLogin
//
//  Created by yoon on 2020/07/29.
//  Copyright © 2020 yeongseok. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var idFailed: UIImageView!
    @IBOutlet weak var pwFailed: UIImageView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var disposeBag = DisposeBag()
    let idValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let pwValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    let idText : BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwText : BehaviorSubject<String> = BehaviorSubject(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInput()
        bindOutput()
    }
    
    func bindInput(){
        
        idTextField.rx.text.orEmpty
            .bind(to: idText)
            .disposed(by: disposeBag)
        
        idText.map(checkId)
            .bind(to: idValid)
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .bind(to: pwText)
            .disposed(by: disposeBag)
        
        pwText.map(checkPw)
            .bind(to: pwValid)
            .disposed(by: disposeBag)
        
        
//        let idInputOb = idTextField.rx.text.orEmpty.asObservable()
//        let idCheckOb = idInputOb.map(checkId)
//
//        let pwInputOb = pwTextField.rx.text.orEmpty.asObservable()
//        let pwCheckOb = pwInputOb.map(checkPw)
        
        
    }
    
    func bindOutput(){
        idValid.subscribe(onNext:{ status in
            if status {
                self.idFailed.backgroundColor = .blue
            }else {
                self.idFailed.backgroundColor = .red
            }
        })
            .disposed(by: disposeBag)
        
        pwValid.subscribe(onNext:{ status in
            if status {
                self.pwFailed.backgroundColor = .blue
            }else {
                self.pwFailed.backgroundColor = .red
            }
        })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            idValid,
            pwValid,
            resultSelector: { $0 && $1 }
        )
            .subscribe(onNext:{
                self.loginBtn.isEnabled = $0
            })
            .disposed(by: disposeBag)
    }
    
    func checkId(email : String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    func checkPw(pass:String) -> Bool {
        if pass.count > 5 {
            return true
        }
        return false
    }
}

