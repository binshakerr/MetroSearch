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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        adjustNavigationBars()
        IQKeyboardManager.shared.enable = true
        return true
    }
    
    func adjustNavigationBars(){
        let tintColor: UIColor = .white  // button colors
        let barTintColor: UIColor = .red // background color
        let titleColor: UIColor = .white // title color
        let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: titleColor, .font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        let largeTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: titleColor, .font: UIFont.systemFont(ofSize: 35, weight: .black)]
        
        let appear = UINavigationBar.appearance()
        appear.tintColor = tintColor
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = barTintColor
            appearance.titleTextAttributes = textAttributes
            appearance.largeTitleTextAttributes = largeTextAttributes
            appear.standardAppearance = appearance
            appear.compactAppearance = appearance
            appear.scrollEdgeAppearance = appearance
        } else {
            // Fallback on earlier versions
            appear.isTranslucent = false
            appear.barTintColor = barTintColor
            appear.titleTextAttributes = textAttributes
            appear.largeTitleTextAttributes = largeTextAttributes
        }
    }
    
    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
     
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }

}
