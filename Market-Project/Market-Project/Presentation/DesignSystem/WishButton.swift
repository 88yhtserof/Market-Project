//
//  WishButton.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/28/25.
//

import UIKit

final class WishButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        tintColor = .white
        configurationUpdateHandler = updateHandler
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isSelected.toggle()
    }
    
    private func updateHandler(_ button: UIButton) {
        switch button.state {
        case .normal:
            configuration = normalConfiguration()
        case .selected:
            configuration = selectedConfiguration()
        default:
            break
        }
    }
    
    private func selectedConfiguration() -> Configuration {
        var config = Configuration.plain()
        config.image = UIImage(systemName: "heart.fill")
        config.baseBackgroundColor = .clear
        return config
    }
    
    private func normalConfiguration() -> Configuration {
        var config = Configuration.plain()
        config.image = UIImage(systemName: "heart")
        return config
    }
}
