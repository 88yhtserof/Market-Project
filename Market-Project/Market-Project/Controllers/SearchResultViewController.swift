//
//  SearchResultViewController.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import UIKit

import SnapKit

class SearchResultViewController: BaseViewController {
    
    //MARK: - Views
    private lazy var mainView = SearchResultMainView(self)
    
    //MARK: - Properties
    private var searchWord: String?
    
    let viewModel = SearchResultViewModel()
    
    //MARK: - Initializers
    init() {
        print("SearchResultViewController init")
        super.init(nibName: nil, bundle: nil)
        bindWhenInit()
    }
    
    //MARK: - LifeCycles
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        bindWhenViewDidLoad()
    }
    
    private func bindWhenInit() {
        /*
         bind 메서드의 호출 시점:
         bind 메서드 호출보다 네트워크 통신 호출이 빠르기 때문에 searchWord는 빈값으로 전달되고 네트워크 통신 오류가 발생한다. 따라서 bind 메서드는 SearchResultVC의 초기화 시점에 호출되어야 한다.
         */
        viewModel.outputSearchWord.lazyBind { [weak self] searchWord in
            guard let self else { return }
            print("outputSearchWord bind")
            self.searchWord = searchWord
            self.navigationItem.title = searchWord
        }
    }
    
    private func bindWhenViewDidLoad() {
        
        viewModel.outputShowErrorAlert.lazyBind { [weak self] errorMessage in
            guard let self else { return }
            print("outputShowErrorAlert bind")
            self.showAlert(title: "검색 오류", message: errorMessage, Style: .alert) {[weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        viewModel.outputTotalItemsCountString.lazyBind { [weak self] total in
            guard let self else { return }
            print("outputTotalItemsCountString bind")
            self.mainView.totalLabel.argument = total
        }
        
        viewModel.outputReloadData.lazyBind { [weak self] _ in
            guard let self else { return }
            print("outputReloadData bind")
            self.mainView.collectionView.reloadData()
        }
        
        viewModel.outputScrollToTop.lazyBind { [weak self] _ in
            guard let self else { return }
            print("outputScrollToTop bind")
            self.mainView.collectionView.contentOffset = .zero
        }
        
        viewModel.inputLoadSearchResult.send()
    }
    
    //MARK: - Actions
    @objc func sortButtonDidTapped(_ sender: SelectButton) {
        sender.isShownSelected = true
        mainView.sortStackView.arrangedSubviews
            .filter{ $0 != sender }
            .compactMap{ $0 as? SelectButton }
            .forEach{ $0.isShownSelected = false }
        
        viewModel.inputSelectSort.send(sender.tag)
    }
}

//MARK: - CollectionView Delegate
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputMarketItems.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else {
            print("Could not find cell")
            return UICollectionViewCell()
        }
        let item = viewModel.outputMarketItems.value[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.inputWillDisplayItems.send(indexPath)
    }
}
