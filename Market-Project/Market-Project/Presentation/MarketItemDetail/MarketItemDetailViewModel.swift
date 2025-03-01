//
//  MarketItemDetailViewModel.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/28/25.
//

import Foundation

import RxSwift
import RxCocoa

final class MarketItemDetailViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let selectWishButton: PublishRelay<Bool>
    }
    
    struct Output {
        let url: Driver<URL?>
        let isWished: Driver<Bool>
    }
    
    private let marketItem: MarketItem
    private let id: String
    private let urlString: String
    
    init(item marketItem: MarketItem) {
        self.marketItem = marketItem
        self.id = marketItem.id
        self.urlString = marketItem.link
    }
    
    func transform(input: Input) -> Output {
        
        let url = BehaviorRelay<URL?>(value: nil)
        let isWished = BehaviorRelay(value: false)
        
        
        Observable.just(urlString)
            .compactMap{ URL(string: $0) }
            .bind(to: url)
            .disposed(by: disposeBag)
        
        
        Observable.just(id)
            .compactMap { WishListManager.shared.isWished($0) }
            .bind(to: isWished)
            .disposed(by: disposeBag)
        
        input.selectWishButton
            .bind(with: self) { owner, isSelected in
                if isSelected {
                    WishListManager.shared.addToWishList(owner.id, item: owner.marketItem)
                } else {
                    WishListManager.shared.removeFromWishList(owner.id)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            url: url.asDriver(),
            isWished: isWished.asDriver()
        )
    }
}
