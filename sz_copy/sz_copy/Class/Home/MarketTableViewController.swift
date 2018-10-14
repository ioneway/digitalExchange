//
//  MarketTableViewController.swift
//  sz_copy
//
//  Created by 王伟 on 2018/10/10.
//  Copyright © 2018年 王伟. All rights reserved.
//

import Foundation
import UIKit

class MarketTableViewController: BaseViewController<MarketTableViewModel>, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        self.viewModel?.subscriptTickMarket()
    }
    
    internal override func bindViewModel() {
        
        let _ = viewModel?.dataSourceVariable.asObservable().bind{ result in
            self.tableView.reloadData()
        }
    }
    private lazy var tableView: UITableView = {
       let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.registerNib(MarketTableViewCell.self)
        temp.separatorStyle = .none
        temp.isScrollEnabled = false //需要分情况设置
        temp.rowHeight = 65
        return temp
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel?.dataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: MarketTableViewCell = tableView.dequeue(indexPath: indexPath)
        cell.model = viewModel?.dataSource[indexPath.row]
        return cell
    }
}

