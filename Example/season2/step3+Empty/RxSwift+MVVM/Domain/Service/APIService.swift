//
//  APIService.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 07/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift
let MenuUrl = "https://firebasestorage.googleapis.com/v0/b/rxswiftin4hours.appspot.com/o/fried_menus.json?alt=media&token=42d5cb7e-8ec4-48f9-bf39-3049e796c936"

class APIService {
    static func fetchAllMenus(onComplete: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: URL(string: MenuUrl)!) { data, res, err in
            if let err = err {
                onComplete(.failure(err))
                return
            }
            guard let data = data else {
                let httpResponse = res as! HTTPURLResponse
                onComplete(.failure(NSError(domain: "no data",
                                            code: httpResponse.statusCode,
                                            userInfo: nil)))
                return
            }
            onComplete(.success(data))
        }.resume()
    }
    //RX를 사용해서 리팩토링하는 경우, 기존 코드를 가지고 수정하지않아도 된다.
    //Result<Data, Error>을 return해주지않고, Data만 해줘도 충분하다. 왜냐면 onError에서 처리가 가능하니
    static func fetchAllMenuRx() -> Observable<Data> {
        return Observable.create(){ emitter in
            fetchAllMenus(onComplete: { (result) in
                switch result {
                case .success(let data) :
                    emitter.onNext(data)
                    emitter.onCompleted()
                case .failure(let err) :
                    emitter.onError(err)
                }
            })
            return Disposables.create()
        }
        //리팩토링된 rxcode
    }
}
