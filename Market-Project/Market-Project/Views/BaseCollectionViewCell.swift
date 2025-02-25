//
//  BaseCollectionViewCell.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
        configureHierarchy()
        configureConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configure Subviews. This method is called after the controller's view is loaded into memory.
    func configureSubviews(){}
    
    /// Configures the view hierarchy. This method is called after the controller's view is loaded into memory.
    func configureHierarchy(){}
    
    /// Configure constraints of views. This method is called after the controller's view is loaded into memory.
    func configureConstraints(){}
}
