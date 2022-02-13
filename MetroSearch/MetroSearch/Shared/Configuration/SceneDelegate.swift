//
//  SceneDelegate.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 13/02/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        setRootViewController(scene: scene)
    }
 
    func createSearchScreen() -> UINavigationController {
        let repo = ObjectRepository(networkManager: NetworkManager.shared)
        let viewModel = SearchViewModel(objectRepository: repo)
        let controller = SearchViewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: controller)
        return navigation
    }

    func setRootViewController(scene: UIWindowScene) {
        window = UIWindow(windowScene: scene)
        window?.rootViewController = createSearchScreen()
        window?.makeKeyAndVisible()
    }
}
