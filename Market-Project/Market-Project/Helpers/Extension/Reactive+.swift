//
//  Reactive+.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/25/25.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var showErrorAlert: Binder<String> {
        return Binder(base) { base, value in
            
            let alert = UIAlertController(title: "오류", message: value, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default)
            alert.addAction(action)
            
            base.present(alert, animated: true)
        }
    }
}
