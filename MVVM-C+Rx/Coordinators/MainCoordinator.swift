//
//  Main.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 10.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import Foundation

extension Coordinators {
    
    var mainCoordinator: P_Coordinator { MainCoordinator(navigationController: base.navigationController, parent: base) }
    
}

class MainCoordinator: BaseCoordinator {
    
    override func start() {
        super.start()
        
        weak var weakRootCoordinator: P_Coordinator! = self.rootCoordinator
        let viewModel = MainVM(
            navigateSignIn: {
                weakRootCoordinator.dismissChildCoordinators()
                weakRootCoordinator.coodinators.signIn.start()
            }
        )
        
        let vc = MainVC.make(with: viewModel)
        present(viewController: vc, type: .root)
    }
    
}
