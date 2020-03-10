//
//  SignUpCoordinator.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import Foundation

extension Coordinators {
    
    var signUp: P_Coordinator { SignUpCoordinator(navigationController: base.navigationController, parent: base) }
    
}

class SignUpCoordinator: BaseCoordinator {
    
    override func start() {
        super.start()
        
        let apiService = ApiService(baseUrl: URL(string: "https://googl.com")!)
        let signUpService = SignUpService(apiSevrice: apiService)
        
        weak var weakRootCoordinator: P_Coordinator! = self.rootCoordinator
        let viewModel = SignUpVM(
            signUpService,
            navigateMain: {
                weakRootCoordinator.dismissChildCoordinators()
                weakRootCoordinator.coodinators.mainCoordinator.start()
            }
        )
        
        let vc = SignUpVC.make(with: viewModel)
        
        
        weak var weakSelf: P_Coordinator! = self
        vc.rx.isMovingFromParent
            .bind(onNext: { weakSelf.dismiss() } )
            .disposed(by: disposeBag)
        
        present(viewController: vc, type: .push)
    }
    
}

import RxSwift
import RxCocoa
extension Reactive where Base: UIViewController {
    
    var isMovingFromParent: ControlEvent<Void> {
        let source = methodInvoked(#selector(UIViewController.viewDidDisappear))
            .map { $0.first as? Bool ?? false }
            .filter { $0 && self.base.isMovingFromParent }
            .map { _ in  }
        return ControlEvent(events: source)
    }
    
}
