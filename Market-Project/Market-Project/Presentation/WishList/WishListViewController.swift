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
    private var snapshot: Snapshot!
    
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
        
        searchController.searchBar.configureDarkMode()
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
    
    typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Int>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Int>
    
    func configureDataSource() {
        let cellRegistration = CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier) as UICollectionViewListCell
            return cell
        })
        
        createSnapshot()
        collectionView.dataSource = dataSource
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, item: Int) {
        var contentConfig = UIListContentConfiguration.valueCell()
        contentConfig.text = "제품명"
        contentConfig.secondaryText = "날짜"
        contentConfig.image = UIImage(systemName: "heart")
        contentConfig.textProperties.color = .white
        contentConfig.imageProperties.tintColor = .systemRed
        contentConfig.secondaryTextProperties.color = .systemGray6
        
        var backgroundConfig = UIBackgroundConfiguration.listCell()
        backgroundConfig.cornerRadius = 10
        backgroundConfig.backgroundColor = .black
        cell.backgroundConfiguration = backgroundConfig
        cell.contentConfiguration = contentConfig
    }
    
    func createSnapshot() {
        snapshot = Snapshot()
        updateSnapshot()
    }
    
    func updateSnapshot() {
        snapshot.appendSections([0])
        snapshot.appendItems([1, 3, 4, 5, 6, 10, 11, 12, 13, 14])
        dataSource.apply(snapshot)
    }
}
