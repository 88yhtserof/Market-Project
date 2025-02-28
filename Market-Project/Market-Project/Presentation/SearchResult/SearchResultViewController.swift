//
//  SearchResultViewController.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SearchResultViewController: BaseViewController {
    
    //MARK: - Views
    private lazy var mainView = SearchResultMainView(self)
    
    //MARK: - Properties
    private var searchWord: String?
    
    private let viewModel: SearchResultViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializers
    init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
        
        print("SearchResultViewController init")
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - LifeCycles
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        bind()
    }
    
    private let sortButtonDidTapped = PublishRelay<Int>()
    
    private func bind() {
        let input = SearchResultViewModel.Input(tapSortButton: sortButtonDidTapped,
                                                scrollList: mainView.collectionView.rx.willDisplayCell.map{ $0.at },
                                                selectItem: mainView.collectionView.rx.modelSelected(MarketItem.self))
        let output = viewModel.transform(input: input)
        
        output.searchText
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        let searchResultItems = output.searchResultItems
            .asDriver()
        
        searchResultItems
            .drive( mainView.collectionView.rx.items(cellIdentifier: SearchResultCollectionViewCell.identifier, cellType: SearchResultCollectionViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)
        
        output.totalSearchResultCount
            .drive(with: self) { owner, text in
                owner.mainView.totalLabel.argument = text
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(rx.showErrorAlert)
            .disposed(by: disposeBag)
        
        output.scrollContentOffset
            .drive(mainView.collectionView.rx.contentOffset)
            .disposed(by: disposeBag)
        
        output.itemForMarketItemDetail
            .compactMap{ $0 }
            .map { MarketItemDetailViewModel(id: $0.id, url: $0.url) }
            .map{ MarketItemDetailViewController(viewModel: $0) }
            .drive(navigationController!.rx.pushViewController)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    @objc func sortButtonDidTapped(_ sender: SelectButton) {
        sender.isShownSelected = true
        mainView.sortStackView.arrangedSubviews
            .filter{ $0 != sender }
            .compactMap{ $0 as? SelectButton }
            .forEach{ $0.isShownSelected = false }
        sortButtonDidTapped.accept(sender.tag)
    }
}
