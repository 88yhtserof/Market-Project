//
//  WhiteLabel.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import UIKit

class WhiteLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
