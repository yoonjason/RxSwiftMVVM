//
//  SearchDataViewModel.swift
//  RxSwiftSearchTableView
//
//  Created by yoon on 2020/07/29.
//  Copyright © 2020 yeongseok. All rights reserved.
//

import Foundation
import RxSwift

class SearchDataViewModel {
    let dataObservable = BehaviorSubject<[SearchData]>(value: [])
    
    init(){
        let d = [
            SearchData(data: "서울"),
            SearchData(data: "경기도"),
            SearchData(data: "강원도"),
            SearchData(data: "충청도"),
            SearchData(data: "전라도"),
            SearchData(data: "경상도"),
            SearchData(data: "충청북도"),
            SearchData(data: "충청남도"),
            SearchData(data: "전라남도"),
            SearchData(data: "전라북도"),
            SearchData(data: "경상남도"),
            SearchData(data: "경상북도"),
            SearchData(data: "제주도"),
            SearchData(data: "울릉도"),
            SearchData(data: "뉴욕"),
            SearchData(data: "로스앤젤레스")
            
        ]

        dataObservable.onNext(d)
    }
    
    
}
