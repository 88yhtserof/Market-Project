//
//  MarketTable.swift
//  Market-Project
//
//  Created by 임윤휘 on 3/4/25.
//

import Foundation

import RealmSwift

class MarketTable: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: String
    @Persisted(indexed: true) var title: String
    @Persisted var image: String
    @Persisted var lprice: String
    @Persisted var mallName: String
    @Persisted var link: String
    
    convenience init(id: String,
                     title: String,
                     image: String,
                     lprice: String,
                     mallName: String,
                     link: String) {
        self.init()
        self.id = id
        self.title = title
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
        self.link = link
    }
}
