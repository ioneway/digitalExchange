//
//  WebViewController.swift
//  sz_copy
//
//  Created by 王伟 on 2018/9/28.
//  Copyright © 2018年 王伟. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseViewController<WebViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRequest()
        self.view.backgroundColor = ColorAsset.BackGround.Level1.color
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func setupUI() {
        view.addSubview(webView)
    }
    
    override func configConstraints() {
        self.webView.frame = view.bounds
    }
    
    private func loadRequest()
    {
       
        let model = viewModel?.params[0]
        var url = "".url
        
        if let model = model as? BannerModel
        {
            self.title = model.name
            url = model.url.url
        }
        
        if let model = model as? AnnouncementModel
        {
            self.title = model.title
            url = model.url.url
        }
        
        if let url = url {
            let request = URLRequest.init(url: url)
            webView.loadRequest(request)
        }
    }
    
    private let webView = UIWebView()
    
}


