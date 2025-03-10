//
//  MarketTableManager.swift
//  Market-Project
//
//  Created by 임윤휘 on 3/4/25.
//

import Foundation

import RealmSwift

final class MarketTableManager {
    
    static var shared = MarketTableManager()
    
    private init(){}
    
    private let realm = try! Realm()
    
    func isWished(_ id: String) -> Bool {
        guard let items = getWishedItems() else { return false }
        return items.contains(where: { $0.id == id })
    }
    
    func getWishedItems() -> Results<MarketTable>? {
        switch RealmProvider.wishTable {
        case .fetchAll(let items):
            return items
        default:
            print("Could not find wish table")
            return nil
        }
    }
    
    func addToWishList(_ id: String, item marketItem: MarketItem) {
        let item = MarketTable(id: marketItem.id, title: marketItem.title, image: marketItem.image, lprice: marketItem.lprice, mallName: marketItem.mallName, link: marketItem.link)
        
        RealmProvider.wishTable = .add(item)
    }
    
    func removeFromWishList(_ id: String) {
        RealmProvider.wishTable = .delete(id)
    }
}
