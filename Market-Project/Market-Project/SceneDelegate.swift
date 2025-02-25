//
//  SceneDelegate.swift
//  Market-Project
//
//  Created by 임윤휘 on 1/15/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let rootVC = SearchViewController()
        let navigationC = UINavigationController(rootViewController: rootVC)
        navigationC.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationC.navigationBar.tintColor = .white
        navigationC.navigationItem.backButtonDisplayMode = .minimal
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigationC
        window?.makeKeyAndVisible()
    }
}

