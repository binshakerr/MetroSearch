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

        setMainViewController()
        IQKeyboardManager.shared.enable = true 
        
        return true
    }

    func setMainViewController(){
        let viewModel = SearchViewModel()
        let controller = SearchViewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: controller)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }

}

