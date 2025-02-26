//
//  SearchViewModel.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/6/25.
//

import Foundation

import RxSwift
import RxCocoa

final class SearchViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let editSearchText: ControlProperty<String>
        let tapSearchButton: ControlEvent<Void>
    }
    
    struct Output {
        let searchText: Driver<String>
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let searchText = PublishRelay<String>()
        let errorMessage = PublishRelay<String>()
        
        input.tapSearchButton
            .withLatestFrom(input.editSearchText)
            .distinctUntilChanged()
            .flatMap{ text in
                return Search.validateSearchWord(text)
                    .debug("ValidateSearchWord")
                    .catch { error in
                        errorMessage.accept(error.localizedDescription)
                        return Observable.just("")
                    }
            }
            .filter{ !$0.isEmpty }
            .debug("tapSearchButton")
            .bind(to: searchText)
            .disposed(by: disposeBag)
        
        
        return Output(searchText: searchText.asDriver(onErrorJustReturn: ""),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: ""))
    }
    
    deinit {
        print("SearchViewModel deinit")
    }
}
