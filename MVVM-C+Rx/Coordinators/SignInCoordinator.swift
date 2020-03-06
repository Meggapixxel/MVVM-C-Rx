//
//  SignInCoordinator.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import Foundation

extension P_Coordinator {
    
    @discardableResult
    func loadSignInCoordinator() -> P_Coordinator {
        let coordinator = SignInCoordinator(navigationController: navigationController, parent: self)
        childCoordinatorStart(coordinator)
        return coordinator
    }
    
}

class SignInCoordinator: BaseCoordinator {
    
    override func start() {
        let apiService = ApiService(baseUrl: URL(string: "https://googl.com")!)
        let signInService = SignInService(apiSevrice: apiService)
        
        weak var weakSelf: SignInCoordinator! = self
        let viewModel = SignInVC.ViewModel(
            signInService,
            navigateSignUp: { weakSelf.loadSignUpCoordinator() }
        )
        let vc = SignInVC.make(with: viewModel)
        present(viewController: vc, type: .root)
    }
    
}
