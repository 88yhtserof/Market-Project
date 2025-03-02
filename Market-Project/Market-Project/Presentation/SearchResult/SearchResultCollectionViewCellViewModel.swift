//
//  SearchResultCollectionViewCellViewModel.swift
//  Market-Project
//
//  Created by 임윤휘 on 3/1/25.
//

import Foundation

import RxSwift
import RxCocoa

final class SearchResultCollectionViewCellViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let tapWishButton: ControlEvent<Void>
        let changedWishButtonSelectedState: ControlProperty<Bool>
    }
    
    struct Output {
        let item: Driver<MarketItem>
        let isWished: Driver<Bool>
        let imageURL: Driver<URL?>
    }
    
    private let item: MarketItem
    private let isWished: Bool
    
    init(item: MarketItem, isWished: Bool) {
        self.item = item
        self.isWished = isWished
    }
    
    deinit {
        print("SearchResultCellViewModel deinit")
    }
    
    func transform(input: Input) -> Output {
        
        let item = BehaviorRelay<MarketItem>(value: self.item)
        let isWished = BehaviorRelay<Bool>(value: self.isWished)
        let imageURL = BehaviorRelay<URL?>(value: URL(string: self.item.image))
        
        input.tapWishButton
            .withLatestFrom(input.changedWishButtonSelectedState)
            .bind(with: self) { owner, isSelected in
                let id = owner.item.id
                if isSelected {
                    WishListManager.shared.addToWishList(id, item: owner.item)
                } else {
                    WishListManager.shared.removeFromWishList(id)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(item: item.asDriver(),
                      isWished: isWished.asDriver(),
                      imageURL: imageURL.asDriver())
    }
}
