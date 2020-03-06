//
//  BaseCoordinator.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import UIKit
import RxSwift

enum PresentationType {
    case root
    case push
    case modal
}

class BaseCoordinator: NSObject, P_Coordinator {
    
    private(set) weak var parent: P_Coordinator?
    private(set) var childCoordinators = [P_Coordinator]()
    private(set) weak var navigationController: UINavigationController!
    let disposeBag = DisposeBag()
    
    // MARK: - Input
    let dismissInput = PublishSubject<Void>()
    
    // MARK: - Output
    private lazy var dismissOutput = dismissInput.take(1).ignoreElements()
    
    required init(navigationController: UINavigationController, parent: P_Coordinator?) {
        self.navigationController = navigationController
        self.parent = parent
        super.init()
    }
    
    func start() {
        fatalError("\(#function) not implemented")
    }
    
    func childCoordinatorStart(_ coordinator: P_Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.start()
        
        weak var weakParent: P_Coordinator! = self
        weak var weakChild: P_Coordinator! = coordinator
        coordinator.onDismiss {
            weakParent.childCoordinatorDidFinish(weakChild)
        }
    }

    func childCoordinatorDidFinish(_ coordinator: P_Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === coordinator } ) else { return }
        coordinator.dismissChildCoordinators()
        childCoordinators.remove(at: index)
    }
    
    func onDismiss(_ completion: @escaping () -> ()) {
        dismissOutput
            .subscribe(onCompleted: completion)
            .disposed(by: disposeBag)
    }
    
    func dismiss() {
        dismissInput.onNext(())
    }
    
    @discardableResult
    func present<VC: P_ViewController>(viewController: VC, type: PresentationType, animated: Bool = true) -> Completable {
        let subject = PublishSubject<Void>()
        switch type {
        case .root:
            navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
                .disposed(by: viewController.disposeBag)
            navigationController.setViewControllers([viewController], animated: animated)
        case .push:
            navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
                .disposed(by: viewController.disposeBag)
            navigationController.pushViewController(viewController, animated: animated)
        case .modal:
            navigationController.present(viewController, animated: animated) { [weak subject] in
                subject?.onCompleted()
            }
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    @discardableResult
    func dismiss<VC: P_ViewController>(viewController: VC, animated: Bool = true) -> Completable {
        let subject = PublishSubject<Void>()
        if viewController == navigationController.presentedViewController {
            viewController.dismiss(animated: animated) { [weak subject] in
                subject?.onCompleted()
            }
        } else if navigationController.viewControllers.last == viewController {
            navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
                .disposed(by: viewController.disposeBag)
            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("\(#function) can't dismiss")
            }
        } else {
            fatalError("\(#function) can't dismiss")
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
}
