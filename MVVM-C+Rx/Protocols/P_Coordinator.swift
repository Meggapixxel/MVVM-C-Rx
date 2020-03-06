//
//  P_Coordinator.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import UIKit

protocol P_Coordinator: class, P_BaseRx {
    
    init(navigationController: UINavigationController, parent: P_Coordinator?)
    
    var parent: P_Coordinator? { get }
    var childCoordinators: [P_Coordinator] { get }
    var navigationController: UINavigationController! { get }
        
    func start()
    func childCoordinatorStart(_ coordinator: P_Coordinator)
    func childCoordinatorDidFinish(_ coordinator: P_Coordinator)
    
    func onDismiss(_ completion: @escaping () -> ())
    func dismiss()
    
}

extension P_Coordinator {
    
    func loadAsRootFirstChild<T: P_Coordinator>(_ childClass: T.Type) -> T {
        let root = rootCoordinator
        let child = T(navigationController: root.navigationController, parent: root)
        root.childCoordinators.forEach { recursiveDismissChildCoordinators($0) }
        root.childCoordinatorStart(child)
        return child
    }
    
    var rootCoordinator: P_Coordinator { recursiveRootCoordinator(self) }
    private func recursiveRootCoordinator(_ coordinator: P_Coordinator) -> P_Coordinator {
        if let parent = coordinator.parent {
            return recursiveRootCoordinator(parent)
        } else {
            return coordinator
        }
    }
    
    func dismissChildCoordinators() {
        childCoordinators.forEach { recursiveDismissChildCoordinators($0) }
    }
    private func recursiveDismissChildCoordinators(_ coordinator: P_Coordinator) {
        coordinator.childCoordinators.forEach {
            recursiveDismissChildCoordinators($0)
            $0.dismiss()
        }
        coordinator.dismiss()
    }

}
