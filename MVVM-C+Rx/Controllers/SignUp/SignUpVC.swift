//
//  SignUpVC.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpVC: UIViewController, P_ViewController {
    
    static var initiableResource: InitializableSource { .xib }
    
    // MARK: - P_BaseRx
    let disposeBag = DisposeBag()
    
    // MARK: - UI
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordCofirmTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!

    // MARK: - P_Bindable
    var viewModel: ViewModel!
    
    func bindViewModel() {
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(to: viewModel.input.signUpDidTap)
            .disposed(by: disposeBag)
        
        weak var weakSelf: SignUpVC! = self
        viewModel.output.errors
            .drive(onNext: { weakSelf.presentError($0) } )
            .disposed(by: disposeBag)
        
        viewModel.output.signUpEnabled
            .drive(signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
}

extension SignUpVC: P_KeyboardViewController {
    
    var isKeyboardObserving: Bool { true }
    
    func keyboardWillShow(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
        scrollView.contentInset.bottom = height
    }
    
    func keyboardWillHide(duration: TimeInterval, options: UIView.AnimationOptions) {
        scrollView.contentInset.bottom = 0
    }
    
}

extension SignUpVC {
    
    class ViewModel: P_ErrorViewModel {
        
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
        let input = Input()
        let output: Output
        
        let errorsSubject = PublishSubject<Error>()
        let disposeBag = DisposeBag()
        
        // MARK: - Private properties
//        private let emailSubject = BehaviorRelay<String>(value: "")
//        private let passwordSubject = BehaviorRelay<String>(value: "")
//        private let signInDidTapSubject = PublishSubject<Void>()
//        private let loginResultSubject = PublishSubject<User>()
        private var credentialsObservable: Observable<Credentials> {
            Observable.combineLatest(
                input.email.asObservable(),
                input.password.asObservable(),
                resultSelector: Credentials.init
            )
        }
        
        // MARK: - Init and deinit
        init(_ signUpService: P_SignUpService) {
            
//            input = Input(
//                email: emailSubject.asObservable(),
//                password: passwordSubject.asObservable(),
//                signInDidTap: signInDidTapSubject.asObserver()
//            )
            
            output = Output(
                signUpEnabled: Driver.combineLatest(
                    input.email.asDriver().map { !$0.isEmpty },
                    input.password.asDriver().map { !$0.isEmpty },
                    Driver.combineLatest(input.password.asDriver(), input.passwordConfirm.asDriver()) { $0 == $1 }
                ) { $0 && $1 && $2 },
                errors: errorsSubject.asDriver(onErrorJustReturn: NSError(domain: "", code: 0, userInfo: nil))
            )
            
            weak var weakSelf: ViewModel! = self
            input.signUpDidTap
                .withLatestFrom(credentialsObservable)
                .flatMapLatest { signUpService.signUp(with: $0) }
                .subscribe(
                    onNext: { _ in print("OK") },
                    onError: { weakSelf.errorsSubject.onNext($0) }
                ).disposed(by: disposeBag)
        }
        
        deinit {
            print(self, #function)
        }
        
    }
    
}
