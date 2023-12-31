//
//  AppDelegate.swift
//  MarvelApp
//
//  Created by mac on 18/09/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigation = UINavigationController.init()
        appCoordinator = AppCoordinator(navCon: navigation)
        appCoordinator?.start()
        
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        return true
    }


}

