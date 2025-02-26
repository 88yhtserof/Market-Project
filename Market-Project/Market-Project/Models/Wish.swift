//
//  Wish.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/26/25.
//

import Foundation

struct Wish: Hashable, Identifiable {
    var id = UUID()
    
    var name: String
    var price: Int = Int.random(in: 1...10) * 1000
    var date: Date = Date()
}
