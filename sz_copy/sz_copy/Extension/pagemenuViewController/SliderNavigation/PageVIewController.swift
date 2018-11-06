////
////  PageVIewController.swift
////  sz_copy
////
////  Created by 王伟 on 2018/10/25.
////  Copyright © 2018 王伟. All rights reserved.
////
//
//import UIKit
//
//class PageVIewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    public let controllers: [UIViewController]
//    public fileprivate(set) var menuView: PageMenuView? {
//        didSet {
//            guard let menuView = menuView else { return }
//            view.addSubview(menuView)
//        }
//    }
//
//    internal lazy var tableView: UITableView = {
//        $0.isPagingEnabled = true
//        $0.delegate = self
//        $0.dataSource = self
//        return $0
//    }(UITableView(frame: .zero))
//    
//    fileprivate var options: PageMenuViewCustomizable! {
//        didSet {
////            cleanup()
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        config()
//    }
//    
//    init(config: PageMenuViewCustomizable) {
//        super.init(nibName: nil, bundle: nil)
////        setup(config)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
////    func cleanup() {
////        if let menuView = self.menuView {
////            menuView.cleanup()
////            menuView.removeFromSuperview()
////        }
////        if let pagingViewController = self.pagingViewController {
////            pagingViewController.cleanup()
////            pagingViewController.view.removeFromSuperview()
////            pagingViewController.removeFromParentViewController()
////            pagingViewController.willMove(toParentViewController: nil)
////        }
////    }
//    
////    func setup(_ config: PageMenuViewCustomizable) {
////        self.config = config
//    
////        switch options.componentType {
////        case .all(let menuOptions, _):
////            self.menuOptions = menuOptions
////        case .menuView(let menuOptions):
////            self.menuOptions = menuOptions
////        default: break
////        }
////
////        setupMenuView()
////        setupMenuController()
////
////        move(toPage: currentPage, animated: false)
////    }
//    
//    
//    
//    func setupUI() {
//        view.addSubview(tableView)
//    }
//    
//    func config() {
//        tableView.snp.makeConstraints{ (make) in
//            make.width.equalTo(view.height)
//            make.height.equalTo(view.width)
//            make.top.equalTo(0)
//        }
//        tableView.transform = CGAffineTransform(rotationAngle: CGFloat(90 * .pi / 180.0));
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeue(indexPath: indexPath)
//        cell.backgroundColor = ColorAsset.BackGround.Level3.color
//        cell.contentView.backgroundColor = ColorAsset.BackGround.Level3.color
//        cell.transform = CGAffineTransform(rotationAngle: CGFloat(90 * .pi / 180.0));
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return kSCREEN_WIDTH
//    }
//}
