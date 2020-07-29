//
//  ViewController.swift
//  RxSwiftMVVMLogin
//
//  Created by yoon on 2020/07/29.
//  Copyright © 2020 yeongseok. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum LoginError : Error {
    case defaultError
    case error(code : Int)
    
    var msg : String {
        switch self {
        case .defaultError:
            return "Enum Error"
        case .error(let code) :
            return "\(code) Error"
        }
    }
}


class ViewController: UIViewController {
    @IBOutlet weak var idTf: UITextField!
    @IBOutlet weak var pwTf: UITextField!
    @IBOutlet weak var idImg: UIImageView!
    @IBOutlet weak var pwImg: UIImageView!
    @IBOutlet weak var signinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

