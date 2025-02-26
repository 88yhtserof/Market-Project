//
//  Search.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import Foundation

import RxSwift

struct Search {
    
    // Returns the word if validated, otherwise return nil.
    static func validateSearchWord(_ word: String) -> Observable<String> {
        return Observable<String>.create { value in
            let trimmedWord = word
                .trimmingCharacters(in: .whitespaces)
                .lowercased()
            
            if trimmedWord.count >= 2 {
                value.onNext(trimmedWord)
                value.onCompleted()
            } else {
                value.onError(SearchError.invalidSearchWord)
            }
            return Disposables.create {
                print("OnDispose")
            }
        }
    }
    
    enum SearchError: LocalizedError {
        case invalidSearchWord
        
        var errorDescription: String? {
            switch self {
            case .invalidSearchWord:
                return "검색어를 2글자 이상 작성하세요"
            }
        }
    }
}
