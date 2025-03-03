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
        let changeWishButtonSelectedState: ControlProperty<Bool>
        let didChangedAnotherWishButtonSelectedState: Observable<[String: MarketItem]>
    }
    
    struct Output {
        let item: Driver<MarketItem>
        let isWished: Driver<Bool>
        let imageURL: Driver<URL?>
        let changedIsWished: Driver<Bool>
    }
    
    private let item: MarketItem
    private let isWished: Bool
    
    init(item: MarketItem) {
        self.item = item
        self.isWished = WishListManager.shared.isWished(item.id)
    }
    
    deinit {
        print("SearchResultCellViewModel deinit")
    }
    
    func transform(input: Input) -> Output {
        
        let item = BehaviorRelay<MarketItem>(value: self.item)
        let isWished = BehaviorRelay<Bool>(value: self.isWished)
        let imageURL = BehaviorRelay<URL?>(value: URL(string: self.item.image))
        let changedIsWished = PublishRelay<Bool>()
        
        input.tapWishButton
            .withLatestFrom(input.changeWishButtonSelectedState)
            .bind(with: self) { owner, isSelected in
                let id = owner.item.id
                if isSelected {
                    WishListManager.shared.addToWishList(id, item: owner.item)
                } else {
                    WishListManager.shared.removeFromWishList(id)
                }
            }
            .disposed(by: disposeBag)
        
        input.didChangedAnotherWishButtonSelectedState
            .withUnretained(self)
            .map{ owner, dictionary in
                dictionary.contains(where: { $0.key == owner.self.item.id })
            }
            .subscribe(onNext: { result in
                changedIsWished.accept(result)
            }, onError: { error in
                print("Error:", error)
            }, onCompleted: {
                print("UserDefaultsManager.$wishList completed")
            }, onDisposed: {
                print("UserDefaultsManager.$wishList disposed")
            })
            .disposed(by: disposeBag)
        
        return Output(item: item.asDriver(),
                      isWished: isWished.asDriver(),
                      imageURL: imageURL.asDriver(),
                      changedIsWished: changedIsWished.asDriver(onErrorJustReturn: false))
    }
}
