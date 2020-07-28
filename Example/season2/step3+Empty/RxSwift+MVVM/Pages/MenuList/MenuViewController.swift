//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {
    // MARK: - Life Cycle
    
    let cellId = "MenuItemTableViewCell"
    
    let viewModel = MenuListViewModel()
    //데이터는 이미 받아왔고, 뷰모델 내에서~ 여기서 생성해주면 전에 받아왔떤 데이터를 보여준다.
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
//        tableView.
        
        /*
         viewmodel에 있는 메뉴값이 나오면 아래와 같이 테이블뷰를 만들어주세요,.
         
         */
        
        viewModel.menuObservable
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: MenuItemTableViewCell.self)) { index, item, cell in
                
                
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"
                
                
                //Cell +,- 처리
                cell.onChange = { [weak self] increase in
                    self?.viewModel.changeCount(item: item, increase: increase)
                }
        }
            .disposed(by: disposeBag)
        //데이터 소스가 필요없다. item은 데이터. index는 indexPath.row cell은 인덱스에 맞는 셀
        
        
//            .
        
        
//        viewModel.itemsCount
//            .map{"\($0)"}
//            .subscribe(onNext:{
//                self.itemCountLabel.text = $0
//            })
//            .disposed(by: disposeBag)
        
        /*
        viewmodel에 menuCount는 문자로 바꿔서 text에 값을 줍니다.
        totalPrice가 나오면 통화형태로 바꿔서 text에 값을 줍니다.
        ViewController에는 view의 요소만 잡아서 어떤 형태로 화면에 뿌릴지 지정한다.

        
        */
        viewModel.itemsCount
            .map{"\($0)"}
            .bind(to: itemCountLabel.rx.text) //-> Subscribe(onNext : {})와 같은 역할을 한다.
            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .scan(0, accumulator: +)//0으로 시작해서 새로운 값이 들어오면 더해준다.
            .map{$0.currencyKR()}
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)
        /*
         여기서 주목할 것은 무언가 데이터가 MenuListViewModel Subject로 만들어놓은 totalPrice에 데이터를 집어넣고 데이터를 추가로 넣고 있는 데, 거기에 의해서 위에가 onNext가 계속 호출된다.
         updateUI()를 호출했을 때는 필요한 시점마다 계속 호출해줬어야 UI가 바꼈는데, 맨 처음 한번만 Subscribe하고 나면 Subscribe에 의해 Next로 데이터가 계속 전달이 되서
         데이터가 계속 바뀌는 것이다.
         
         
         .subscribe(onNext : { [weak self] in
             self?.totalPrice.text = $0
         })
         //self를 처리하기 위해서 [weak self] in 를 넣고 self?를 사용하면 순환참조가 없어진다.
         bind를 사용하면 순환참조 없이 사용이 가능하다.
         
         
         */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == "OrderViewController",
            let orderVC = segue.destination as? OrderViewController {
            // TODO: pass selected menus
        }
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - InterfaceBuilder Links
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!
    
    @IBAction func onClear() {
        viewModel.clearAllItemSelections()
        //viewModel로 넘겼다.
    }
    
    @IBAction func onOrder(_ sender: UIButton) {
        // TODO: no selection
        // showAlert("Order Fail", "No Orders")
        //        performSegue(withIdentifier: "OrderViewController", sender: nil)
    //Observable
//        viewModel.totalPrice.onNext(100) //100원씩 넣어준다.
//        viewModel.menuObservable.onNext([Menu(name: "changed", price: 100, count: 2)]) //viewModel MenuObservable에 값을 넣어준다.
//        viewModel.menuObservable.onNext([Menu(name: "changed", price: Int.random(in: 100...1000), count: Int.random(in: 0...3))]) //viewModel MenuObservable에 값을 넣어준다.
        
//        viewModel.menuObservable.onNext([Menu(id : 0, name: "changed", price: Int.random(in: 100...1000), count: Int.random(in: 0...3)), Menu(id : 1, name: "changed", price: Int.random(in: 100...1000), count: Int.random(in: 0...3)), Menu(id : 2, name: "changed", price: Int.random(in: 100...1000), count: Int.random(in: 0...3))])
        
        
        /*
         이렇게 바껴서 돌아가는 순간,데이터가 새로 들어가서 초기화했던 메뉴들이 없어지고, 하나로 바뀔 것이다.
         아이템 카운트가 바뀌
         */
        
        //나중에는 viewModel로 넘길것이다.
        viewModel.onOrder()
    }

}

//extension MenuViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.menus.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as! MenuItemTableViewCell
//
//        let menu = viewModel.menus[indexPath.row]
//
//        cell.title.text = menu.name
//        cell.price.text = "\(menu.price)"
//        cell.count.text = "\(menu.count)"
//
//        return cell
//    }
//}
