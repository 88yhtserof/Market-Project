//
//  SearchViewModel.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/6/25.
//

import Foundation

class SearchViewModel {
    
    // IN
    let inputSearchKeyword: Observable<String?> = Observable(nil)
    
    // OUT
    let outputShowSearchResult: Observable<String?> = Observable(nil)
    
    init() {
        print("SearchViewModel init")
        
        inputSearchKeyword.lazyBind { [weak self] keyword in
            print("inputSearchKeyword: \(keyword)")
            guard let self else { return }
            var searchWord: String? = nil
            
            if let keyword {
                searchWord = Search.validateSearchWord(keyword)
            }
            self.outputShowSearchResult.send(searchWord)
        }
    }
    
    deinit {
        print("SearchViewModel deinit")
    }
    
    
}
