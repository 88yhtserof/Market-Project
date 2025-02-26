//
//  WishListViewController.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/26/25.
//

import UIKit

import RxSwift
import RxCocoa

final class WishListViewController: BaseViewController {
    
    private let searchController = UISearchController()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private var dataSource: DataSource!
    
    private let viewModel = WishListViewModel()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        bind()
    }
    
    //MARK: - Configuration
    override func configureSubviews() {
        navigationItem.title = "위시 리스트"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.configureDarkMode(placeholder: "갖고 싶은 상품을 기록하세요")
    }
    
    override func configureHierarchy() {
        view.addSubviews([collectionView])
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Bind
    private func bind() {
        
        let selectItem = PublishRelay<Wish>()
        
        let input = WishListViewModel.Input(searchText: searchController.searchBar.rx.text.orEmpty,
                                            tapSearchButton: searchController.searchBar.rx.searchButtonClicked,
                                            selectItem: selectItem)
        let output = viewModel.transform(input: input)
        
        output.emptySearchBarText
            .drive(searchController.searchBar.rx.text)
            .disposed(by: disposeBag)
        
        output.wishItems
            .drive(rx.updateSnapshot)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap{ owner, indexPath in
                owner.dataSource.itemIdentifier(for: indexPath)
            }
            .bind(to: selectItem)
            .disposed(by: disposeBag)
    }
}

//MARK: - CollectionView Layout
private extension WishListViewController {
    
    func layout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = .clear
        return UICollectionViewCompositionalLayout { _, environment in
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: environment)
            section.interGroupSpacing = 10
            return section
        }
    }
}

//MARK: - CollectionView DataSource
private extension WishListViewController {
    
    typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Wish>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Wish>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Wish>
    
    func configureDataSource() {
        let cellRegistration = CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier) as UICollectionViewListCell
            return cell
        })
        
        updateSnapshot(for: [])
        collectionView.dataSource = dataSource
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, item: Wish) {
        var contentConfig = UIListContentConfiguration.valueCell()
        contentConfig.text = item.name
        contentConfig.secondaryText = item.date.formatted()
        contentConfig.image = UIImage(systemName: "heart.fill")
        contentConfig.textProperties.color = .white
        contentConfig.imageProperties.tintColor = .systemRed
        contentConfig.secondaryTextProperties.color = .systemGray6
        
        var backgroundConfig = UIBackgroundConfiguration.listCell()
        backgroundConfig.cornerRadius = 10
        backgroundConfig.backgroundColor = .black
        cell.backgroundConfiguration = backgroundConfig
        cell.contentConfiguration = contentConfig
    }
    
    func updateSnapshot(for items: [Wish]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
}

private extension Reactive where Base: WishListViewController {
    var updateSnapshot: Binder<[Wish]> {
        Binder(base) { base, value in
            base.updateSnapshot(for: value)
        }
    }
}
