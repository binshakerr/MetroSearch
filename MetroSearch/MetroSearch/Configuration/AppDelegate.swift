//
//  AppDelegate.swift
//  MetroSearch
//
//  Created by Eslam Shaker on 10/11/2021.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setRootViewController()
        IQKeyboardManager.shared.enable = true 
        
        return true
    }
    
    func createSearchScreen() -> UINavigationController {
        let repo = ObjectRepository(networkManager: NetworkManager.shared)
        let viewModel = SearchViewModel(objectRepository: repo)
        let controller = SearchViewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: controller)
        return navigation
    }

    func setRootViewController(){
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = createSearchScreen()
        window?.makeKeyAndVisible()
    }

}

