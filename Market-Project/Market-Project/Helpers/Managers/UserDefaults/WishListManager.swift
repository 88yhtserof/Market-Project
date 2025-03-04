//
//  WishListManager.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/28/25.
//

import Foundation

final class WishListManager {
    
    static var shared = WishListManager()
    
    private init(){}
    
    func isWished(_ id: String) -> Bool {
        UserDefaultsManager.wishList[id] != nil
    }
    
    func addToWishList(_ id: String, item marketItem: MarketItem) {
        UserDefaultsManager.wishList[id] = marketItem // wishList 화면 제작 예정
    }
    
    func removeFromWishList(_ id: String) {
        UserDefaultsManager.wishList[id] = nil
    }
}
