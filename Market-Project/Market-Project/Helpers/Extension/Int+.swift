//
//  Int+.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import Foundation

extension Int {
    static let decimalFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    /// Returns a string containing the formatted value with decimal.
    func decimal() -> String? {
        let nsNumber = NSNumber(value: self)
        return Int.decimalFormatter.string(from: nsNumber)
    }
}
