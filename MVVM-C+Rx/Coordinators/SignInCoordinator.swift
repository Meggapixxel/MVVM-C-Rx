//
//  SignInCoordinator.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import Foundation

extension Coordinators {
    
    var signIn: P_Coordinator { SignInCoordinator(navigationController: base.navigationController, parent: base) }
    
}

class SignInCoordinator: BaseCoordinator {
    
    override func start() {
        super.start()
        
        let apiService = ApiService(baseUrl: URL(string: "https://googl.com")!)
        let signInService = SignInService(apiSevrice: apiService)
        
        weak var weakSelf: SignInCoordinator! = self
        weak var weakRootCoordinator: P_Coordinator! = self.rootCoordinator
        let viewModel = SignInVM(
            signInService,
            navigateSignUp: { weakSelf.coodinators.signUp.start() },
            navigateMain: {
                weakRootCoordinator.dismissChildCoordinators()
                weakRootCoordinator.coodinators.mainCoordinator.start()
            }
        )
        
        let vc = SignInVC.make(with: viewModel)
        present(viewController: vc, type: .root)
    }
    
}
