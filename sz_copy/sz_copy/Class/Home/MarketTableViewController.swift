//
//  MarketTableViewController.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/10.
//  Copyright © 2018年 王伟. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class MarketTableViewController: BaseViewController<MarketTableViewModel>, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorAsset.BackGround.Level3.color
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    internal override func bindViewModel() {
        
        let _ = viewModel?.dataSourceVariable.asObservable().bind{ result in
           self.tableView.reloadData()
        }.dispose()
        
        let _ = APPTransactionPair.default.coinValueChangeIndexVariable.asObservable().bind{ result in
            if result.keys.first == self.viewModel?.coinName && result.values.first != -1 && (self.viewModel?.dataSource.count ?? 0) > 0{
                self.tableView.reloadRows(at: [IndexPath.init(row: result.values.first ?? 0, section: 0)], with: UITableViewRowAnimation.none)
            }
        }
        
        let _ = APPTransactionPair.default.exTickDatasVariable.asObservable().bind{ result in
            self.tableView.reloadData()
        }
    }
    
    public lazy var tableView: UITableView = {
       let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.bounces = false
        temp.registerNib(MarketTableViewCell.self)
        let view = UIView()
        view.backgroundColor = ColorAsset.BackGround.Level3.color
        temp.backgroundView = view
        temp.separatorStyle = .none
        temp.rowHeight = 65
        return temp
    }()
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel?.dataSource.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MarketTableViewCell = tableView.dequeue(indexPath: indexPath)
        cell.model = viewModel?.dataSource[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView == scrollView as! UITableView {
            let rect = self.view.convert(view.bounds, to: AppDelegate.default.window)
            log (rect)
            if (rect.minY <= 124) {
//                scrollView.contentOffset.y = 0
            }
        }
    }
    

}

