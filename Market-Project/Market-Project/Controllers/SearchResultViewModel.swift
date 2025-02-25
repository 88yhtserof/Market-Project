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
        let errorMessage: BehaviorRelay<String?>
    }
    
    private let searchText: String
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
        let errorMessage = BehaviorRelay<String?>(value: nil)
        
        searchText
            .withUnretained(self)
            .flatMap { (owner, text) in
                NetworkManager.shared
                    .getShopList(searchWord: text, sort: owner.sort, start: String(owner.start))
                    .debug("getShopList")
                    .catch { error in
                        errorMessage.accept(error.localizedDescription)
                        return Single<MarketResponse?>.just(nil)
                    }
            }
            .debug("searchText")
            .compactMap{ $0 }
            .bind(with: self) { (owner, response) in
                owner.start += NetworkManager.Pagenation.market.display
                owner.total = response.total
                totalSearchResultCount.accept(response.total.decimal() ?? "")
                searchResultItems.accept(response.items)
            }
            .disposed(by: disposeBag)
        
        return Output(searchText: searchText,
                      searchResultItems: searchResultItems,
                      totalSearchResultCount: totalSearchResultCount,
                      errorMessage: errorMessage)
    }
    
//    // IN
//    let inputLoadSearchResult: Observable<Void> = Observable(())
//    let inputWillDisplayItems: Observable<IndexPath?> = Observable(nil)
//    let inputSelectSort: Observable<Int> = Observable(0)
//    
//    // OUT
//    let outputSearchWord: Observable<String?> = Observable(nil)
//    let outputMarketItems: Observable<[MarketItem]> = Observable([])
//    let outputShowErrorAlert: Observable<String> = Observable("")
//    let outputTotalItemsCountString: Observable<String> = Observable("")
//    let outputReloadData: Observable<Void> = Observable(())
//    let outputScrollToTop: Observable<Void> = Observable(())
    
//    // DAT
    
//    init() {
//        print("SearchResultViewModel init")
        
//        inputLoadSearchResult.lazyBind { [weak self] _ in
//            guard let self else { return }
//            print("inputLoadSearchResult bind")
//            self.loadMarketItems(sort: self.sort, isInitialLoad: true)
//        }
//        
//        inputWillDisplayItems.lazyBind { [weak self] indexPath in
//            guard let self else { return }
//            print("inputWillDisplayItems bind")
//            guard let indexPath else { return }
//            self.willDisplay(at: indexPath)
//        }
//        
//        inputSelectSort.lazyBind { [weak self] sortNumber in
//            guard let self else { return }
//            print("inputSelectSort bind")
//            self.didSelectSort(sortNumber)
//        }
//    }
    
    deinit {
        print("SearchResultViewModel deinit")
    }
    
//    private func loadMarketItems(sort: MarketItemSort, isInitialLoad: Bool) {
//        guard let searchWord = outputSearchWord.value else { return }
//        NetworkManager.shared.getShopList(searchWord: searchWord, sort: sort, start: String(start)) {(value, error) in
//            if let error {
//                self.outputShowErrorAlert.send(error)
//                return
//            }
//            
//            guard let value else { return }
//            if isInitialLoad {
//                self.start = 0
//                self.outputMarketItems.send([])
//                self.outputTotalItemsCountString.send(value.total.decimal() ?? "")
//            }
//            self.outputMarketItems.value.append(contentsOf: value.items)
//            self.start += NetworkManager.Pagenation.market.display
//            self.total = value.total
//            self.outputReloadData.send(())
//        }
//    }
//    
//    private func willDisplay(at indexPath: IndexPath) {
//        let items = outputMarketItems.value
//        guard items.count != self.total else { return }
//        
//        if (items.count - 2) == indexPath.item {
//            loadMarketItems(sort: sort, isInitialLoad: false)
//        }
//    }
//    
//    private func didSelectSort(_ sortNumber: Int) {
//        guard let sort = MarketItemSort(rawValue: sortNumber) else {
//            print("Unknown sort")
//            return
//        }
//        guard self.sort != sort else {
//            print("already selected")
//            return
//        }
//        self.sort = sort
//        self.outputScrollToTop.send()
//        self.loadMarketItems(sort: sort, isInitialLoad: true)
//    }
}
