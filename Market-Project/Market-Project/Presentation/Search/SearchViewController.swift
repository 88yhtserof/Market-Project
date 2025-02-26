//
//  SearchViewController.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController {
    
    private let wishListBarButtonItem = UIBarButtonItem()
    private let searchBar = UISearchBar()
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    //MARK: - Configuration
    override func configureSubviews() {
        navigationItem.title = SceneCategory.search.title
        navigationItem.rightBarButtonItem = wishListBarButtonItem
        
        wishListBarButtonItem.target = self
        wishListBarButtonItem.image = UIImage(systemName: "heart.fill")
        
        searchBar.configureDarkMode(placeholder: "브랜드, 상품, 프로필, 태그 등")
    }
    
    override func configureHierarchy() {
        view.addSubviews([searchBar])
    }
    
    override func configureConstraints() {
        let inset: CGFloat = 8
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(inset)
        }
    }
    
    //MARK: - Bind
    private func bind() {
        
        let input = SearchViewModel.Input(editSearchText: searchBar.rx.text.orEmpty,
                                          tapSearchButton: searchBar.rx.searchButtonClicked)
        let output = viewModel.transform(input: input)
        
        output.searchText
            .drive(with: self, onNext: { owner, text in
                let viewModel = SearchResultViewModel(searchText: text)
                let searchResultVC = SearchResultViewController(viewModel: viewModel)
                owner.navigationController?.pushViewController(searchResultVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.errorMessage
            .debug("errorMessage")
            .drive(rx.showErrorAlert)
            .disposed(by: disposeBag)
        
        wishListBarButtonItem.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                let wishVC = WishListViewController()
                owner.navigationController?.pushViewController(wishVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

enum SceneCategory: String {
    case search = "쇼핑 검색"
    
    var title: String {
        return rawValue
    }
}
