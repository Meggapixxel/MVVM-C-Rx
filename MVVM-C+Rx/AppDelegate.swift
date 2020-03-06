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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let apiService = ApiService(baseUrl: URL(string: "")!)
        let loginService = SignInService(apiSevrice: apiService)
        let loginControllerViewModel = SignInController.ViewModel(loginService)
        let loginController = SignInController.make(with: loginControllerViewModel)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = loginController
        window?.makeKeyAndVisible()
        
        return true
    }

}
