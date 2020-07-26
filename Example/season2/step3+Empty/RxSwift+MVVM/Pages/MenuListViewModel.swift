//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by yoon on 2020/07/26.
//  Copyright © 2020 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift

class MenuListViewModel {
//    var menus : [Menu] = [
//        Menu(name: "튀김", price: 100, count: 0),
//        Menu(name: "튀김", price: 100, count: 0),
//        Menu(name: "튀김", price: 100, count: 0),
//        Menu(name: "튀김", price: 100, count: 0)
//    ]
        
    
//    lazy var menuObservable = Observable.just(menus)
    
//    lazy var menuObservable = PublishSubject<[Menu]>()
    lazy var menuObservable = BehaviorSubject<[Menu]>(value: [])
    //초기값을 갖는다. 빈 문자열로 넣어준다.  init에서 next로 넣어준다.viewModel이 생성되는 시점에 메뉴가 채워질 것이고, 나중에 테이블뷰가 Subscribe가 했을 때 가장 최근에 들어갔던 메뉴를 가지고 온다.
    
    /*
     Menu array를 다루는 애다.
     Menu array가 외부로 부터 주어지면 그 때마다 Observable이 반응을 할 것이다.
    하나의 Observable이
     init할 때 데이터가 만들어진다.
     */
    
//    var itemsCount : Int = 5
    lazy var itemsCount = menuObservable.map{
        $0.map{  $0.count}.reduce(0, +)
    }
    
//    var totalPrice : PublishSubject<Int> = PublishSubject()
    lazy var totalPrice = menuObservable.map{
        $0.map{ $0.price * $0.count}.reduce(0, +)
    }
    
    
    init() {
        let menus : [Menu] = [
            Menu(name: "튀김", price: 100, count: 0),
            Menu(name: "튀김", price: 100, count: 0),
            Menu(name: "튀김", price: 100, count: 0),
            Menu(name: "튀김", price: 100, count: 0)
        ]
        
        menuObservable.onNext(menus)
    }
    /*
     
     */
    
    
    /*
     Subject Observable처럼 값을 받아먹을 수도 있지만, 외부에서 값을 통제할 수도 있다.
     totalPrice는 결국에는 메뉴 중에서 menu * count의 총합 아니냐.
     */
}
