//
//  ViewController.swift
//  RxSwiftSearchTableView
//
//  Created by yoon on 2020/07/29.
//  Copyright © 2020 yeongseok. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TableViewCell : UITableViewCell {
    
    @IBOutlet weak var searchLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedLabel: UILabel!
    
    var disposeBag = DisposeBag()
    let viewModel = SearchDataViewModel()
    
    var items = [String]()
    let samples = ["서울", "부산", "온수", "건대", "온수", "부천", "송파", "가", "가나", "가나다", "가나다라", "가카타파하", "에이", "a", "ab", "abc", "apple", "mac", "azxy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
        input()
        viewModel.dataObservable
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "TableViewCell", cellType: TableViewCell.self)) { (index, item, cell) in
                cell.searchLabel.text = item.data
        }
        .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .subscribe(onNext:{
                a in
                
            })
            .disposed(by: disposeBag)
        
               

        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext:{ searchText in
                _ = self.viewModel.dataObservable.map{ searchDatas in
                    print("######")
                    self.viewModel.dataObservable.onNext(
                        searchDatas.filter{
                            $0.data.hasPrefix(searchText)
                        }
                    )
                    print(searchText)
                }
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
    }

    func input(){
        
        self.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)   //0.5초 기다림
            .distinctUntilChanged()   // 같은 아이템을 받지 않는기능
            .subscribe(onNext: { t in
                self.items = self.samples.filter{ $0.hasPrefix(t) }
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
    }

}

//extension ViewController : UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell
//        cell?.searchLabel.text = self.items[indexPath.row]
//        return cell!
//    }
//
//
//}
