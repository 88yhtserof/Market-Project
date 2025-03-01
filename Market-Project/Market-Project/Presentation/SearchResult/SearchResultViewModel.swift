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
        let selectItem: ControlEvent<(MarketItem, Bool)>
    }
    
    struct Output {
        let searchText: Driver<String>
        let searchResultItems: Driver<[(MarketItem, Bool)]>
        let totalSearchResultCount: Driver<String>
        let errorMessage: Driver<String>
        let scrollContentOffset: Driver<CGPoint>
        let itemForMarketItemDetail: Driver<MarketItem?>
    }
    
    private let searchText: String
    private var searchResultItems: [(MarketItem, Bool)] = []
    private var start: Int = 1
    private var total: Int = 0
    private var sort: MarketItemSort = .sim
    
    init(searchText: String) {
        self.searchText = searchText
    }
    
    func transform(input: Input) -> Output {
        
        let searchText = BehaviorRelay<String>(value: searchText)
        let searchResultItems = BehaviorRelay<[(MarketItem, Bool)]>(value: [])
        let totalSearchResultCount = BehaviorRelay<String>(value: "")
        let errorMessage = PublishRelay<String>()
        let scrollContentOffset = PublishRelay<CGPoint>()
        let itemForMarketItemDetail = PublishRelay<MarketItem?>()
        
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
                    .map{ ($0, WishListManager.shared.isWished($0.id)) }
                
                searchResultItems.accept(owner.searchResultItems)
                 scrollContentOffset.accept(.zero)
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
                
                let newItems = response.items
                    .map{ ($0, WishListManager.shared.isWished($0.id)) }
                
                owner.searchResultItems.append(contentsOf: newItems)
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
        
        input.selectItem
            .map{ $0.0 }
            .bind(to: itemForMarketItemDetail)
            .disposed(by: disposeBag)

        return Output(searchText: searchText.asDriver(),
                      searchResultItems: searchResultItems.asDriver(),
                      totalSearchResultCount: totalSearchResultCount.asDriver(),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: ""),
                      scrollContentOffset: scrollContentOffset.asDriver(onErrorJustReturn: .zero),
                      itemForMarketItemDetail: itemForMarketItemDetail.asDriver(onErrorJustReturn: nil))
    }
    
    deinit {
        print("SearchResultViewModel deinit")
    }
}
