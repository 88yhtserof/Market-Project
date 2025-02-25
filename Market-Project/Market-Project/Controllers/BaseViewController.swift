//
//  BaseViewController.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import UIKit

/// A base view controller for all view controllers in this project
class BaseViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        configureSubviews()
        configureHierarchy()
        configureConstraints()
    }
    
    /// Configure Subviews. This method is called after the controller's view is loaded into memory.
    func configureSubviews(){}
    
    /// Configures the view hierarchy. This method is called after the controller's view is loaded into memory.
    func configureHierarchy(){}
    
    /// Configure constraints of views. This method is called after the controller's view is loaded into memory.
    func configureConstraints(){}
}
