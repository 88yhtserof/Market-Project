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
        let didChangedAnotherWishButtonSelectedState: Observable<Result<Update<MarketTable, String>, any Error>>
    }
    
    struct Output {
        let item: Driver<MarketItem>
        let isWished: Driver<Bool>
        let imageURL: Driver<URL?>
        let changedIsWished: Driver<Bool>
        let errorMessage: Driver<String>
    }
    
    private let item: MarketItem
    private let isWished: Bool
    
    init(item: MarketItem) {
        self.item = item
        self.isWished = MarketTableManager.shared.isWished(item.id)
    }
    
    deinit {
        print("SearchResultCellViewModel deinit")
    }
    
    func transform(input: Input) -> Output {
        
        let item = BehaviorRelay<MarketItem>(value: self.item)
        let isWished = BehaviorRelay<Bool>(value: self.isWished)
        let imageURL = BehaviorRelay<URL?>(value: URL(string: self.item.image))
        let changedIsWished = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
        
        input.tapWishButton
            .withLatestFrom(input.changeWishButtonSelectedState)
            .bind(with: self) { owner, isSelected in
                let id = owner.item.id
                if isSelected {
                    MarketTableManager.shared.addToWishList(id, item: owner.item)
                } else {
                    MarketTableManager.shared.removeFromWishList(id)
                }
            }
            .disposed(by: disposeBag)
        
        input.didChangedAnotherWishButtonSelectedState
            .withUnretained(self)
            .compactMap{ owner, result in
                
                switch result {
                case .success(let update):
                    switch update {
                    case .add(let table):
                        return table.id == owner.item.id ? true : nil
                    case .delete(let id):
                        return id == owner.self.item.id ? false : nil
                    default:
                        return nil
                    }
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                    return nil
                }
            }
            .subscribe(onNext: { result in
                changedIsWished.accept(result)
            }, onError: { error in
                print("Error:", error)
            }, onCompleted: {
                print("RealmProvider.$wishTable completed")
            }, onDisposed: {
                print("RealmProvider.$wishTable disposed")
            })
            .disposed(by: disposeBag)
        
        return Output(item: item.asDriver(),
                      isWished: isWished.asDriver(),
                      imageURL: imageURL.asDriver(),
                      changedIsWished: changedIsWished.asDriver(onErrorJustReturn: false),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: ""))
    }
}
