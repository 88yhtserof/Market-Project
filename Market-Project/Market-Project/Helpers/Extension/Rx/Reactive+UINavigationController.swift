//
//  Reactive+UINavigationController.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/28/25.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UINavigationController {
    var pushViewController: Binder<UIViewController> {
        return Binder(base) { base, value in
            base.pushViewController(value, animated: true)
        }
    }
}
