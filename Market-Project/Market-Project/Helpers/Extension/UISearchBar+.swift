//
//  UISearchBar+.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/26/25.
//

import UIKit

extension UISearchBar {
    func configureDarkMode() {
        self.backgroundImage = UIImage()
        self.searchTextField.backgroundColor = .white.withAlphaComponent(0.1)
        self.searchTextField.tintColor = .systemGray2
        self.searchTextField.textColor = .systemGray2
        self.searchTextField.leftView?.tintColor = .systemGray2
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드, 상품, 프로필, 태그 등",
                                                                        attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray2])
    }
}
