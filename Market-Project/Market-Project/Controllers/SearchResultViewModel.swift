//
//  SearchResultViewModel.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/6/25.
//

import Foundation

import RxSwift
import RxCocoa

final class SearchResultViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let tapSortButton: PublishRelay<Int>
        let scrollList: Observable<IndexPath>
    }
    
    struct Output {
        let searchText: BehaviorRelay<String>
        let searchResultItems: BehaviorRelay<[MarketItem]>
        let totalSearchResultCount: BehaviorRelay<String>
        let errorMessage: PublishRelay<String>
    }
    
    private let searchText: String
    private var searchResultItems: [MarketItem] = []
    private var start: Int = 1
    private var total: Int = 0
    private var sort: MarketItemSort = .sim
    
    init(searchText: String) {
        self.searchText = searchText
    }
    
    func transform(input: Input) -> Output {
        
        let searchText = BehaviorRelay<String>(value: searchText)
        let searchResultItems = BehaviorRelay<[MarketItem]>(value: [])
        let totalSearchResultCount = BehaviorRelay<String>(value: "")
        let errorMessage = PublishRelay<String>()
        
        searchText
            .withUnretained(self)
            .flatMap { (owner, text) in
                NetworkManager.shared
                    .getShopList(searchWord: text, sort: owner.sort, start: String(owner.start))
                    .debug("getShopList")
                    .catch { error in
                        if let error = error as? NetworkError {
                            errorMessage.accept(error.errorMessageForUser)
                        }
                        return Single<MarketResponse?>.just(nil)
                    }
            }
            .debug("searchText")
            .compactMap{ $0 }
            .bind(with: self) { (owner, response) in
                owner.start = NetworkManager.Pagenation.market.display
                owner.total = response.total
                totalSearchResultCount.accept(response.total.decimal() ?? "")
                owner.searchResultItems = response.items
                searchResultItems.accept(owner.searchResultItems)
            }
            .disposed(by: disposeBag)
        
        let pagination: Observable<Void> = input.scrollList
            .withLatestFrom(searchResultItems){ ($0, $1) }
            .withUnretained(self)
            .filter{ owner, value in
                let (indexPath, items) = value
                return (items.count < owner.total) && ((items.count - 1) == indexPath.item)
            }
            .map{ _, _ in Void() }
        
        
        pagination
            .withUnretained(self)
            .withLatestFrom(searchText){ ($0.0, $1) }
            .flatMap{ (owner, text) in
                NetworkManager.shared
                    .getShopList(searchWord: text, sort: owner.sort, start: String(owner.start))
                    .debug("getShopList pagination")
                    .catch { error in
                        if let error = error as? NetworkError {
                            errorMessage.accept(error.errorMessageForUser)
                        }
                        return Single<MarketResponse?>.just(nil)
                    }
            }
            .debug("pagination")
            .compactMap{ $0 }
            .bind(with: self) { (owner, response) in
                owner.start += NetworkManager.Pagenation.market.display
                owner.total = response.total
                owner.searchResultItems.append(contentsOf: response.items)
                searchResultItems.accept(owner.searchResultItems)
            }
            .disposed(by: disposeBag)
        
        input.tapSortButton
            .distinctUntilChanged()
            .compactMap{ MarketItemSort(rawValue: $0) }
            .bind(with: self) { owner, sort in
                owner.sort = sort
                searchText.accept(owner.searchText)
            }
            .disposed(by: disposeBag)

        return Output(searchText: searchText,
                      searchResultItems: searchResultItems,
                      totalSearchResultCount: totalSearchResultCount,
                      errorMessage: errorMessage)
    }
    
    deinit {
        print("SearchResultViewModel deinit")
    }
}
