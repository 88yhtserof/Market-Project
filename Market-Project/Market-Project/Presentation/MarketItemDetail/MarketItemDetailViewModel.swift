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
        
    }
    
    struct Output {
        let url: Driver<URL?>
        let isWished: Driver<Bool>
    }
    
    private let id: String
    private let urlString: String
    
    init(id: String, url: String) {
        self.id = id
        self.urlString = url
    }
    
    func transform(input: Input) -> Output {
        
        let url = BehaviorRelay<URL?>(value: nil)
        let isWished = BehaviorRelay(value: false)
        
        
        Observable.just(urlString)
            .compactMap{ URL(string: $0) }
            .bind(to: url)
            .disposed(by: disposeBag)
        
        
        return Output(
            url: url.asDriver(),
            isWished: isWished.asDriver()
        )
    }
}
