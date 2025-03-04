//
//  WishListGridViewController.swift
//  Market-Project
//
//  Created by 임윤휘 on 3/5/25.
//

//
//  WishListViewController.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/26/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class WishListGridViewController: BaseViewController {
    
    //MARK: - Views
    private let searchController = UISearchController()
    private lazy var mainView = WishListGridMainView(self)
    
    //MARK: - Properties
    private var searchWord: String?
    
    private let viewModel: WishListGridViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializers
    init(viewModel: WishListGridViewModel) {
        self.viewModel = viewModel
        
        print("WishListGridViewController init")
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - LifeCycles
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.delegate = self
        
        navigationItem.title = "위시 리스트"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.configureDarkMode(placeholder: "갖고 싶은 상품을 기록하세요")
        
        bind()
    }
    
    private let sortButtonDidTapped = PublishRelay<Int>()
    
    private func bind() {
        let input = WishListGridViewModel.Input(selectItem: mainView.collectionView.rx.modelSelected(MarketTable.self))
        let output = viewModel.transform(input: input)
        
        output.searchText
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        let searchResultItems = output.searchResultItems
            .asDriver()
        
        searchResultItems
            .drive( mainView.collectionView.rx.items(cellIdentifier: SearchResultCollectionViewCell.identifier, cellType: SearchResultCollectionViewCell.self)) { row, element, cell in
                
                let item = MarketItem(id: element.id, title: element.title, image: element.image, lprice: element.lprice, mallName: element.mallName, link: element.link)
                let viewModel = SearchResultCollectionViewCellViewModel(item: item)
                cell.bind(viewModel: viewModel)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(rx.showErrorAlert)
            .disposed(by: disposeBag)
        
        output.itemForMarketItemDetail
            .compactMap{ $0 }
            .map { MarketItemDetailViewModel(item: $0) }
            .map{ MarketItemDetailViewController(viewModel: $0) }
            .drive(navigationController!.rx.pushViewController)
            .disposed(by: disposeBag)
    }
}
