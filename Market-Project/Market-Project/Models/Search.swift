//
//  Search.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import Foundation

struct Search {
    
    // Returns the word if validated, otherwise return nil.
    static func validateSearchWord(_ word: String) -> String? {
        let trimmedWord = word.trimmingCharacters(in: .whitespaces).lowercased()
        return trimmedWord.count < 2 ? nil : trimmedWord
    }
}
