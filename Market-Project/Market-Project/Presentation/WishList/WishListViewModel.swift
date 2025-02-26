//
//  WishListViewModel.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/26/25.
//

import Foundation

import RxSwift
import RxCocoa

final class WishListViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchText: ControlProperty<String>
        let tapSearchButton: ControlEvent<Void>
//        let selectItem: PublishRelay<Int>
    }
    
    struct Output {
        let wishItems: Driver<[Wish]>
        let emptySearchBarText: Driver<String>
//        let selectedItem: Driver<Int>
    }
    
    private var wishItems: [UUID: Wish] = [:]
    
    func transform(input: Input) -> Output {
        
        let wishItems = PublishRelay<[Wish]>()
//        let selectedItem = PublishRelay<Int>()
        let emptySearchBarText = PublishRelay<String>()
        
        input.tapSearchButton
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map{ Wish(name: $0) }
            .withUnretained(self)
            .map { (owner, item) in
                owner.wishItems.updateValue(item, forKey: item.id)
                return owner.wishItems
            }
            .map { items in
                items.map{ $0.value }.sorted(by: { $0.date > $1.date })
            }
            .bind(to: wishItems)
            .disposed(by: disposeBag)
        
        
        input.tapSearchButton
            .map{ "" }
            .bind(to: emptySearchBarText)
            .disposed(by: disposeBag)
        
        return Output(wishItems: wishItems.asDriver(onErrorJustReturn: []), emptySearchBarText: emptySearchBarText.asDriver(onErrorJustReturn: ""))
//                      selectedItem: selectedItem.asDriver(onErrorJustReturn: 0)
//        )
    }
}
