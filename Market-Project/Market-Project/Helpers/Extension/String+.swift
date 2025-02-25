//
//  String+.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/16/25.
//

import Foundation

extension String {
    var replacingHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+(>|$)|&quot;|<b>|</b>",
                                         with: "",
                                         options: .regularExpression,
                                         range: nil)
    }
}
