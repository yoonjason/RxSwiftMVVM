//
//  Menu.swift
//  RxSwift+MVVM
//
//  Created by yoon on 2020/07/26.
//  Copyright © 2020 iamchiwon. All rights reserved.
//

import Foundation


// Model : View를 위한 Model
// ViewModel
struct Menu {
    var id : Int
    var name : String
    var price  : Int
    var count : Int
}
extension Menu {
    static func fromMenuItems(id : Int, item : MenuItem) -> Menu {
        return Menu(id: 0, name: item.name, price: item.price, count: 0)
    }
 }
