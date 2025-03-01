//
//  Market.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import Foundation

struct MarketResponse: Decodable {
    let total: Int
    let start: Int // 검색 시작 위치(기본값: 1, 최댓값: 1000)
    let display: Int // 한 번에 표시할 검색 결과 개수(기본값: 10, 최댓값: 100)
    let items: [MarketItem]
}

struct MarketItem: Codable, Identifiable {
    
    var id: String
    
    let title: String
    let image: String
    let lprice: String
    let mallName: String
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case title, image, lprice, mallName, link
    }
}

enum MarketItemSort: Int {
    case sim, date, highPrice, lowPrice
    
    var value: String {
        switch self {
        case .sim:
            return "sim"
        case .date:
            return "date"
        case .highPrice:
            return "dsc"
        case .lowPrice:
            return "asc"
        }
    }
}
