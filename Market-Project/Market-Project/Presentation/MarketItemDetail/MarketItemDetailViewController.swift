//
//  MarketItemDetailViewController.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/27/25.
//

import UIKit
import WebKit

import SnapKit
import RxSwift
import RxCocoa

final class MarketItemDetailViewController: BaseViewController {
    
    private let wishButton = WishButton()
    private let webView = WKWebView(frame: .zero)
    
    private let viewModel: MarketItemDetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MarketItemDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureSubviews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: wishButton)
    }
    
    override func configureHierarchy() {
        view.addSubviews([webView])
    }
    
    override func configureConstraints() {
        webView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        let changeWishButtonState = PublishRelay<Bool>()
        
        let input = MarketItemDetailViewModel.Input(selectWishButton: changeWishButtonState)
        let output = viewModel.transform(input: input)
        
        output.url
            .compactMap{ $0 }
            .drive(webView.rx.load)
            .disposed(by: disposeBag)
        
        output.isWished
            .drive(wishButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        wishButton.rx.tap
            .withUnretained(self)
            .map{ owner, _ in owner.wishButton.isSelected }
            .bind(to: changeWishButtonState)
            .disposed(by: disposeBag)
    }
}
