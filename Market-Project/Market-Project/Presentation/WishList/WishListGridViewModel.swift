//
//  WishListGridViewModel.swift
//  Market-Project
//
//  Created by 임윤휘 on 3/5/25.
//

import Foundation

import RealmSwift
import RxSwift
import RxCocoa

final class WishListGridViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let editSearchText: ControlProperty<String>
        let selectItem: ControlEvent<MarketTable>
        let didChangedAnotherWishButtonSelectedState: Observable<Result<Update<MarketTable, String>, any Error>>
    }
    
    struct Output {
        let searchText: Driver<String>
        let searchResultItems: Driver<[MarketTable]>
        let errorMessage: Driver<String>
        let itemForMarketItemDetail: Driver<MarketItem?>
    }
    
    private var searchText: String
    
    init(searchText: String) {
        self.searchText = searchText
    }
    
    func transform(input: Input) -> Output {
        
        let searchText = BehaviorRelay<String>(value: searchText)
        let searchResultItems = BehaviorRelay<[MarketTable]>(value: [])
        let errorMessage = PublishRelay<String>()
        let itemForMarketItemDetail = PublishRelay<MarketItem?>()
        
        searchText
            .compactMap { text in
                if text.isEmpty {
                    return MarketTableManager.shared.getWishedItems()
                } else {
                    print(text)
                    guard let list = MarketTableManager.shared.getWishedItems() else {return nil}
                    return list.where{ $0.title.contains(text, options: .caseInsensitive) }
                }
            }
            .map{ Array($0) }
            .bind(to: searchResultItems)
            .disposed(by: disposeBag)
        
        input.selectItem
            .map{ MarketItem(id: $0.id, title: $0.title, image: $0.image, lprice: $0.lprice, mallName: $0.mallName, link: $0.link) }
            .bind(to: itemForMarketItemDetail)
            .disposed(by: disposeBag)
        
        input.didChangedAnotherWishButtonSelectedState
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let update):
                    switch update {
                    case .delete(_):
                        // 개선 필요
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { //Exclusive Lock 해결 목적
                            searchText.accept(owner.searchText)
                        }
                    default:
                        break
                    }
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
            } onDisposed: { _ in
                print("WishListGridViewController dispose")
            }
            .disposed(by: disposeBag)
        
        input.editSearchText
            .bind(with: self, onNext: { owner, text in
                owner.searchText = text
                searchText.accept(text)
            })
            .disposed(by: disposeBag)
        
        return Output(searchText: searchText.asDriver(),
                      searchResultItems: searchResultItems.asDriver(),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: ""),
                      itemForMarketItemDetail: itemForMarketItemDetail.asDriver(onErrorJustReturn: nil))
    }
    
    deinit {
        print("WishListGridViewModel deinit")
    }
}
