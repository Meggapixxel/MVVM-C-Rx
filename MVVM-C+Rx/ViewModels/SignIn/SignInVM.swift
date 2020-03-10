//
//  SignInVM.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 10.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import RxSwift
import RxCocoa

final class SignInVM: BaseViewModel<SignInVM.Input, SignInVM.Output>, P_ViewModelViewController {
    
    struct Input {
        let email = BehaviorRelay<String>(value: "")
        let password = BehaviorRelay<String>(value: "")
        let signInDidTap = PublishSubject<Void>()
        let signUpDidTap = PublishSubject<Void>()
    }
    struct Output {
        let signInEnabled: Driver<Bool>
        let errors: Driver<Error>
    }
    
    // MARK: - Public properties
    let errorsSubject = PublishSubject<Error>()
    
    // MARK: - Private properties
    private var credentialsObservable: Observable<Credentials> {
        Observable.combineLatest(
            input.email.asObservable(),
            input.password.asObservable(),
            resultSelector: Credentials.init
        )
    }
    
    // MARK: - Init
    init(_ signInService: P_SignInService, navigateSignUp: @escaping () -> (), navigateMain: @escaping () -> ()) {
        let input = Input()
        super.init(
            input: input,
            output: Output(
                signInEnabled: Driver.combineLatest(
                    input.email.asDriver().map { !$0.isEmpty },
                    input.password.asDriver().map { !$0.isEmpty }
                ) { $0 && $1 },
                errors: errorsSubject.asDriver(onErrorJustReturn: NSError(domain: "", code: 0, userInfo: nil))
            )
        )
        
        input.signUpDidTap.bind(onNext: navigateSignUp).disposed(by: disposeBag)
        
        weak var weakSelf: SignInVM! = self
        input.signInDidTap
            .withLatestFrom(credentialsObservable)
            .flatMapLatest { signInService.signIn(with: $0) }
            .subscribe(
                onNext: { _ in navigateMain() },
                onError: { weakSelf.errorsSubject.onNext($0) }
            ).disposed(by: disposeBag)
    }
    
}
