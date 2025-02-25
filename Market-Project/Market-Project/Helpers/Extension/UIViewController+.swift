//
//  UIViewController+.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/17/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, Style: UIAlertController.Style, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: Style)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
