//
//  UIView+.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import UIKit

extension UIView {

    /// Add views sequentially to the receiver's list of subviews.
    func addSubviews(_ views: [UIView]) {
        views.forEach{ self.addSubview($0) }
    }
    
    /// Clips this view to its bounding frame, with the specified corner radius.
    func cornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
