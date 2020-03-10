//
//  SignUpVM.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 10.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import RxSwift
import RxCocoa

final class SignUpVM: BaseViewModel<SignUpVM.Input, SignUpVM.Output>, P_ViewModelViewController {
    
    struct Input {
        let email = BehaviorRelay<String>(value: "")
        let password = BehaviorRelay<String>(value: "")
        let passwordConfirm = BehaviorRelay<String>(value: "")
        let signUpDidTap = PublishSubject<Void>()
    }
    struct Output {
        let signUpEnabled: Driver<Bool>
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
    
    // MARK: - Init and deinit
    required init(_ signUpService: P_SignUpService, navigateMain: @escaping () -> ()) {
        let input = Input()
        
        let password = input.password.asDriver()
        let passwordConfirm = input.passwordConfirm.asDriver()
        super.init(
            input: input,
            output: Output(
                signUpEnabled: Driver.combineLatest(
                    input.email.asDriver().map { !$0.isEmpty },
                    password.map { !$0.isEmpty },
                    Driver.combineLatest(password, passwordConfirm) { $0 == $1 }
                ) { $0 && $1 && $2 },
                errors: errorsSubject.asDriver(onErrorJustReturn: NSError(domain: "", code: 0, userInfo: nil))
            )
        )
        
        weak var weakSelf: SignUpVM! = self
        input.signUpDidTap
            .withLatestFrom(credentialsObservable)
            .flatMapLatest { signUpService.signUp(with: $0) }
            .subscribe(
                onNext: { _ in navigateMain() },
                onError: { weakSelf.errorsSubject.onNext($0) }
            ).disposed(by: disposeBag)
    }
    
}
