//
//  FormatStringLabel.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import UIKit

class FormatStringLabel: UILabel {
    
    let format: String
    var argument: String {
        didSet {
            text = String(format: format, argument)
        }
    }
    init(format: String, argument: String) {
        self.format = format
        self.argument = argument
        super.init(frame: .zero)
        self.text = String(format: format, argument)
    }
    
    convenience init(format: String) {
        self.init(format: format, argument: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
