//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"


//class 나중에생기는데이터<T> {
//class Observable<T> {
//    private let task : (@escaping (T) -> Void) -> Void
//
//    init(task : @escaping(@escaping (T) -> Void) -> Void) {
//        self.task = task
//    }
//
//    func subscribe(_ f: @escaping (T) -> Void) {
//        task(f)
//    }
//
//}

class ViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }

    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
//    func downloadJson(_ url : String, _ completion : @escaping (String?) -> Void) {
//        DispatchQueue.global().async {
//            let url = URL(string: MEMBER_LIST_URL)!
//            let data = try! Data(contentsOf: url)
//            let json = String(data: data, encoding: .utf8)
//            DispatchQueue.main.async {
//                completion(json)
//            }
//        }
//    }
    
//    func downloadJson(_ url : String) -> Observable<String?> {
//        //Observable클래스가 있을 때
//        return Observable(){ f in
//            DispatchQueue.global().async {
//                let url = URL(string: url)!
//                let data = try! Data(contentsOf: url)
//                let json = String(data: data, encoding: .utf8)
//
//                DispatchQueue.main.async {
//                    f(json)
//                }
//            }
//
//        }
//    }
    
    func downloadJson(_ url : String) -> Observable<String?> {
        //1. 비동기로 생기는 데이터를  Observable로 감싸서 리턴하는 방법
        
        return Observable.create() { emitter in
            let url = URL(string: url)!
            let task = URLSession.shared.dataTask(with: url){ (data, _, err) in
                guard err == nil else {
                    //에러는 nil이어야하니, 에러가 있으면 아래를 탄다. 가드문
                    emitter.onError(err!)
                    return
                }
                
                if let dat = data, let json = String(data: dat, encoding: .utf8) {
                    //에러가 안생겼고 데이터가 제대로 왔다면, json의 String까지 제대로 만들어졌다면 onNext로 데이터가 전달이 됨
                    emitter.onNext(json)
                    //데이터가 준비되지 않으면 complete시킨다.
                }
                emitter.onCompleted()
                
                
            }
            
            task.resume()
//            emitter.onNext("Hello")
//            emitter.onNext("World")
//            emitter.onCompleted()
            
            return Disposables.create() {
                //Observable이 생성되었을 때, cancel을 시킨다.
                task.cancel()
            }
        }
        /*
         Observable을 만드는 형태는 항상 이렇다.
         create를 사용해서 emitter로다가
         Next, Complete, Error를 보내는 방식으로 사용한다.
         */
        
        
//        return Observable.create { f in
//            DispatchQueue.global().async {
//                let url = URL(string: url)!
//                let data = try! Data(contentsOf: url)
//                let json = String(data: data, encoding: .utf8)
//
//                DispatchQueue.main.async {
//                    f.onNext(json)
//                    f.onCompleted()
//                    //onCompleted를 사용하면 올라갔던 레퍼런스 카운트도 없어지므로 순환참조는 발생하지않는다.
//                }
//            }
//            return Disposables.create()
//        }
    }

    
    // MARK: SYNC

    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBAction func onLoad() {
        editView.text = ""
        self.setVisibleWithAnimation(self.activityIndicator, true)
        
//        let json = self.downloadJson(MEMBER_LIST_URL)
//        downloadJson(MEMBER_LIST_URL, { json in
//            self.editView.text = json
//            self.setVisibleWithAnimation(self.activityIndicator, false)
//        })

//        downloadJson(MEMBER_LIST_URL)
//            .subscribe{ json in
//                //Observable클래스가 있을 때
//                self.editView.text = json
//                self.setVisibleWithAnimation(self.activityIndicator, false)
//
//        }
        
        //            //2.  Observable로 오는 데이터를 받아서 처리하는 방법
//        downloadJson(MEMBER_LIST_URL).subscribe{ event in //emiiter.onNext로 한 데이터들이 들어온다.
//            switch (event) {
//            case let .next(json) :
//                DispatchQueue.main.async {
//                    self.editView.text = json
//                    self.setVisibleWithAnimation(self.activityIndicator, false)
//                }
//            case .completed :
//                break
//            case .error:
//                break
//            }
//
//        }

        //            //2.  Observable로 오는 데이터를 받아서 처리하는 방법
//        let ob = downloadJson(MEMBER_LIST_URL)
//        let disp =  ob.subscribe{ event in //emiiter.onNext로 한 데이터들이 들어온다.
//            switch (event) {
//            case let .next(json) :
//                DispatchQueue.main.async {
//                    self.editView.text = json
//                    self.setVisibleWithAnimation(self.activityIndicator, false)
//                }
//            case .completed :
//                break
//            case .error:
//                break
//            }
//        }
//        disp.dispose()
        
        //2.  Observable로 오는 데이터를 받아서 처리하는 방법
//        downloadJson(MEMBER_LIST_URL)
//            .debug() // 데이터가 전달되는 동안에 디버그에 걸리면 다 찍힌다.
//            .subscribe{ event in //emiiter.onNext로 한 데이터들이 들어온다.
//
//                switch (event) {
//                case let .next(json) :
//                    DispatchQueue.main.async {
//                        self.editView.text = json
//                        self.setVisibleWithAnimation(self.activityIndicator, false)
//                    }
//                case .completed :
//                    break
//                case .error:
//                    break
//                }
//        }
        
         
        let observable = downloadJson(MEMBER_LIST_URL)
        
        //2.  Observable로 오는 데이터를 받아서 처리하는 방법
        let disposable = observable.subscribe { event in // -> 이 클로져가 순환참조를 일으킨다. 이 클로저는 이 Observable이 종료가 되면 사라진다.
            //Observable의 종료가 되는 조건은 completed, error, disposed가 됐을 때
            switch event {
            case .next(let json) :
                break;
            case .error(let err) :
                break;
            case .completed:
                break
            }
            
        }
        //필요에 따라서 disposable을 취소할 수 있다.
//        disposable.dispose()
        
    }
}
