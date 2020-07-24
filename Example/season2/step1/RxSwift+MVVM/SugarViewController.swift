//
//  SugarViewController.swift
//  RxSwift+MVVM
//
//  Created by yoon on 2020/07/24.
//  Copyright © 2020 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON

class SugarViewController: UIViewController {
    
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
    
//    func downloadJson(_ url : String) -> Observable<String?> {
//        //1. 비동기로 생기는 데이터를  Observable로 감싸서 리턴하는 방법
//        //데이터 하나 보내는 것은 just로 그냥 쓰자
////        return Observable.just("Hello World")
////        return Observable.just(["Hello", "World"])
//        return Observable.from(["Hello", "World"]) //sugar Api
//
////        return Observable.create() { emitter in
////            emitter.onNext("Hello World")
////            emitter.onCompleted()
////            return Disposables.create()
////        }
//
//
//    }
    func downloadJson(_ url : String) -> Observable<String> {
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
        
     
        
//
//       let jsonObservable =  downloadJson(MEMBER_LIST_URL)
//            .observeOn(MainScheduler.instance) //sugar operator 메인쓰레도 쓰레드를 전환한다는 개념으로 보면 된다.
//            .map {json in json?.count ?? 0} //sugar operator
//            .filter{ cnt in cnt > 0} //sugar operator
//            .map{ "\($0)"} //sugar operator
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)) // downloadJson부터 ConcurrentDispatch
//            .subscribe(onNext:{ json in
//                self.editView.text = json
//                self.setVisibleWithAnimation(self.activityIndicator, false)
//            })
        /*
         default qos를 갖는 DispatchQueue 쓰레드에서 처음부터(downloadJson)부터 observeOn 에서 쓰레드가 전환된다.
         첫 번째 어디쓰레드에서 동작할 건지를 지정해주는 거기 때문에 subscribeOn은 위치가 상관없다.
         
         */
        //2.  Observable로 오는 데이터를 받아서 처리하는 방법
        /*
         매번 에러 컴프리트를 할 필요까진 없다.
         */
//        _ = observable.subscribe(onNext : { print($0) }, onError : { err in print(err)}, onCompleted: {print("Complete")})
        
            
        
        //필요에 따라서 disposable을 취소할 수 있다.
        //        disposable.dispose()

        let jsonObservable =  downloadJson(MEMBER_LIST_URL)
        let helloObservable = Observable.just("Hello World")
            
        Observable.zip(jsonObservable, helloObservable){ $1 + "\n" + $0}
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)) // downloadJson부터 ConcurrentDispatch
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext:{ json in
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            })
        
        
    }
}
