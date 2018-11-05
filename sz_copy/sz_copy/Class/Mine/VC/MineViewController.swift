//
//  HomeViewController.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/19.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController<MineViewModel>, UITableViewDataSource, UITableViewDelegate {
    lazy var _tableview: UITableView = {
       let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.rowHeight = 62
        temp.separatorColor = ColorAsset.Block.Seperate.color.withAlphaComponent(0.15)
        let backView = UIView()
        backView.backgroundColor = ColorAsset.BackGround.Level3.color
        temp.backgroundView = backView
        temp.tableHeaderView = MineHeaderView()
        temp.tableHeaderView?.height = 106
        temp.tableFooterView = UIView.init(frame: .zero)
        temp.registerClass(MineTableViewCell.self)
        return temp
    }()
    
    var models: [MineTableViewCell.Item] = {
        typealias Item = MineTableViewCell.Item
        return [Item(icon: ImgAsset.dollar.image, title: "我的资产".local),
                Item(icon: ImgAsset.location.image, title: "提币地址".local),
                Item(icon: ImgAsset.security.image, title: "安全中心".local),
                Item(icon: ImgAsset.help.image, title: "帮助中心".local),
                Item(icon: ImgAsset.gift.image, title: "邀请返佣".local),
                Item(icon: ImgAsset.digitalNode.image, title: "数字节点".local)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            _tableview.contentInsetAdjustmentBehavior = .never
        }
        
        let item = UIBarButtonItem(image: ImgAsset.setting.image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(naviBtnClick))
        self.navigationItem.rightBarButtonItem = item
        
        
        
        setupUI()
        configConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func setupUI() {
        super.setupUI()
        view.addSubview(_tableview)
    }
    
    override func configConstraints() {
        super.configConstraints()
        _tableview.snp.makeConstraints{ make in
            make.left.top.bottom.right.equalToSuperview()
        }
    }
    
    /// 导航栏按钮点击
    @objc func naviBtnClick() {
        //进入设置页面
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MineTableViewCell = tableView.dequeue(indexPath: indexPath)
        cell.model = models[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
