//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by yoon on 2020/07/26.
//  Copyright © 2020 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift
/*
 어떤 로직을 정해야할지는 ViewModel
 어떤 데이터를 보여줘야되느냐 그 데이터를 보여주는데 Clear나 +,-를 누르면 어떤 처리를 해줘야하는지는.
 ViewModel이 알고 있다.
 에러가 있다면 viewModel이 알고 있다.
 tableViewCell에서 - 누르면 -값으로 내려간다. -> viewModel이 해줘야한다.
 
 */
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
    
    init(){
        /*
         기존 레거시 코드가 있었는 데, rx로 사용할 수 있도록 감싸서 리팩토링 해서 사용해서 데이터를 얻었고, 서버에서 제공해주는 스펙에 따라서
         모델을 만들고 나면, MenuItem같이 생겼는데, MenuItem이 아니고 Menu로 미리 예상해서 만들어놨으므로, Menu처럼 만들었다.
         */
        _ = APIService.fetchAllMenuRx()
            .map { data -> [MenuItem] in
                struct Response : Decodable {
                    let menus: [MenuItem]
                }
                let response = try! JSONDecoder().decode(Response.self, from: data)
                return response.menus
        }
        .map{ menuItems -> [Menu] in
            var menus : [Menu] = []
            menuItems.enumerated().forEach{ index, item in
                let menu = Menu.fromMenuItems(id: index, item: item)
                menus.append(menu)
            }
            return menus
        }
        .take(1)
        .bind(to: menuObservable)
        
    }
    
    
//    init() {
//        let menus : [Menu] = [
//            Menu(id : 0, name: "튀김", price: 100, count: 0),
//            Menu(id : 1, name: "튀김", price: 100, count: 0),
//            Menu(id : 2, name: "튀김", price: 100, count: 0),
//            Menu(id : 3, name: "튀김", price: 100, count: 0)
//        ]
//
//        menuObservable.onNext(menus)
//    }
    
    
    func clearAllItemSelections() {
        
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    Menu(id: m.id, name: m.name, price: m.price, count: 0)
                }
        }
        .take(1)
        .subscribe(onNext : {
            self.menuObservable.onNext($0)
        })
        
        //        _ = menuObservable
        //            .map { menus in
        //                menus.map { m in
        //                    Menu(name: m.name, price: m.price, count: 0)
        //                }
        //        }
        //        .take(1)
        //        .subscribe(onNext:{
        //            self.menuObservable.onNext($0)
        //        })
    }
    
    /*
     
     */
    
    
    /*
     Subject -> Observable처럼 값을 받아먹을 수도 있지만, 외부에서 값을 통제할 수도 있다.
     totalPrice는 결국에는 메뉴 중에서 menu * count의 총합 아니냐.
     */
    
    func changeCount(item : Menu, increase : Int) {
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    if m.id == item.id {
                        return Menu(id : m.id, name: m.name, price: m.price, count: max(m.count + increase, 0))//최소 0까지만
                    }else {
                        return Menu(id : m.id, name: m.name, price: m.price, count: m.count)
                    }
                }
        }
        .take(1)
        .subscribe(onNext : {
            self.menuObservable.onNext($0)
        })
    }
    /*
     +, - 누르거나 새로운 menuset이 만들어져서 Observable로 값이 전달되어 새로운 값이 만들어져 값이 내려가게된다.
     */
    
    func onOrder(){
        
    }
}
