//
//  AppCoordinator.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import Foundation

class AppCoordinator: BaseCoordinator {
    
    override func start() {
        coodinators.signIn.start()
    }
    
}
