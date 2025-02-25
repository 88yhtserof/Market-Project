//
//  SearchViewController.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import UIKit

import SnapKit

class SearchViewController: BaseViewController {
    private let searchBar = UISearchBar()
    
    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configureSubviews() {
        navigationItem.title = SceneCategory.search.title
        
        searchBar.delegate = self
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
        viewModel.outputShowSearchResult.lazyBind { [weak self] searchWord in
            guard let self else { return }
            print("outputShowSearchResult bind")
            if let searchWord {
                let searchResultVC = SearchResultViewController()
                searchResultVC.viewModel.outputSearchWord.send(searchWord)
                self.navigationController?.pushViewController(searchResultVC, animated: true)
            } else {
                self.showAlert(title: "검색어 입력 오류", message: "2글자 이상 작성하세요", Style: .alert)
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearchKeyword.send(searchBar.text)
        searchBar.text = nil
        view.endEditing(true)
    }
}

enum SceneCategory: String {
    case search = "쇼핑 검색"
    
    var title: String {
        return rawValue
    }
}
