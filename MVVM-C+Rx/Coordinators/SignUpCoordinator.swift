//
//  SignUpCoordinator.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import Foundation

extension P_Coordinator {
    
    @discardableResult
    func loadSignUpCoordinator() -> P_Coordinator {
        let coordinator = SignUpCoordinator(navigationController: navigationController, parent: self)
        childCoordinatorStart(coordinator)
        return coordinator
    }
    
}

class SignUpCoordinator: BaseCoordinator {
    
    override func start() {
        let apiService = ApiService(baseUrl: URL(string: "https://googl.com")!)
        let signUpService = SignUpService(apiSevrice: apiService)
        let viewModel = SignUpVC.ViewModel(signUpService)
        let vc = SignUpVC.make(with: viewModel)
        present(viewController: vc, type: .push)
    }
    
}
