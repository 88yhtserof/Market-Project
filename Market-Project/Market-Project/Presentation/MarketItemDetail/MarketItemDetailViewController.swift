//
//  MarketItemDetailViewController.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/27/25.
//

import UIKit
import WebKit

import SnapKit

class MarketItemDetailViewController: BaseViewController {
    
    var webView = WKWebView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "https://www.apple.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func configureSubviews() {
        view.addSubviews([webView])
    }
    
    override func configureHierarchy() {
        webView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}
