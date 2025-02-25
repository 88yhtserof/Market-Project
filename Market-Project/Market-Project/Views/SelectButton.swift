//
//  SelectButton.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/16/25.
//

import UIKit

class SelectButton: UIButton {
    
    var isShownSelected: Bool {
        didSet {
            self.configuration = isShownSelected ? selectedConfiguration : unselectedConfiguration
        }
    }
    
    private var selectedConfiguration = UIButton.Configuration.filled()
    private var unselectedConfiguration = UIButton.Configuration.filled()
    
    init(title: String, isSelected: Bool = false){
        self.isShownSelected = isSelected
        super.init(frame: .zero)
        selectedConfiguration.title = title
        selectedConfiguration.baseForegroundColor = .black
        selectedConfiguration.baseBackgroundColor = .white
        
        unselectedConfiguration.title = title
        unselectedConfiguration.baseForegroundColor = .white
        unselectedConfiguration.baseBackgroundColor = .black
        self.configuration = isShownSelected ? selectedConfiguration : unselectedConfiguration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
