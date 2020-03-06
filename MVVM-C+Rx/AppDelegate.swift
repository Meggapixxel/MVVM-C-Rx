//
//  AppDelegate.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let navigationController = UINavigationController()
    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appCoordinator = AppCoordinator(navigationController: navigationController, parent: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        appCoordinator.start()
        
        return true
    }

}
