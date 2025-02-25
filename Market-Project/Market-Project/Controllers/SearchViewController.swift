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
    private let searchBar = UISearchBar()
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureSubviews() {
        navigationItem.title = SceneCategory.search.title
        
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .white.withAlphaComponent(0.1)
        searchBar.searchTextField.tintColor = .systemGray2
        searchBar.searchTextField.textColor = .systemGray2
        searchBar.searchTextField.leftView?.tintColor = .systemGray2
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드, 상품, 프로필, 태그 등",
                                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray2])
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
    
    private func bind() {
        
        let input = SearchViewModel.Input(editSearchText: searchBar.rx.text.orEmpty,
                                          tapSearchButton: searchBar.rx.searchButtonClicked)
        let output = viewModel.transform(input: input)
        
        output.searchText
            .bind(with: self, onNext: { owner, text in
                let viewModel = SearchResultViewModel(searchText: text)
                let searchResultVC = SearchResultViewController(viewModel: viewModel)
                owner.navigationController?.pushViewController(searchResultVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.errorMessage
            .bind(to: rx.showErrorAlert)
            .disposed(by: disposeBag)
    }
}

enum SceneCategory: String {
    case search = "쇼핑 검색"
    
    var title: String {
        return rawValue
    }
}
