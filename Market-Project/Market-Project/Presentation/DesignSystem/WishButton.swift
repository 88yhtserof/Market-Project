//
//  WishButton.swift
//  Market-Project
//
//  Created by 임윤휘 on 2/28/25.
//

import UIKit

import RxSwift
import RxCocoa

final class WishButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        configureView()
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
}

private extension WishButton {
    
    func configureView() {
        tintColor = .white
        configurationUpdateHandler = updateHandler
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.6
    }
    
    func selectedConfiguration() -> Configuration {
        var config = Configuration.plain()
        config.image = UIImage(systemName: "heart.fill")
        config.baseBackgroundColor = .clear
        return config
    }
    
    func normalConfiguration() -> Configuration {
        var config = Configuration.plain()
        config.image = UIImage(systemName: "heart")
        return config
    }
}

extension Reactive where Base: WishButton {
    var isSelectedState: ControlProperty<Bool> {
        return controlProperty(editingEvents: [.touchUpInside]) { button in
            return button.isSelected
        } setter: { button, value in
            button.isSelected = value
        }
    }
}
