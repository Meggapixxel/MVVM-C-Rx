//
//  SignInVC.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInVC: UIViewController, P_ViewController {
    
    static var initiableResource: InitializableSource { .storyboard(storyboard: UIStoryboard(name: "Main", bundle: nil)) }
    
    // MARK: - P_BaseRx
    let disposeBag = DisposeBag()
    
    // MARK: - UI
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!

    // MARK: - P_Bindable
    var viewModel: ViewModel!
    
    func bindViewModel() {
        emailTextfield.rx.text.orEmpty
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)
        
        passwordTextfield.rx.text.orEmpty
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .bind(to: viewModel.input.signInDidTap)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(to: viewModel.input.signUpDidTap)
            .disposed(by: disposeBag)
        
        weak var weakSelf: SignInVC! = self
        viewModel.output.errors
            .drive(onNext: { weakSelf.presentError($0) } )
            .disposed(by: disposeBag)
        
        viewModel.output.signInEnabled
            .drive(signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
}

extension SignInVC: P_KeyboardViewController {
    
    var isKeyboardObserving: Bool { true }
    
    func keyboardWillShow(height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
        scrollView.contentInset.bottom = height
    }
    
    func keyboardWillHide(duration: TimeInterval, options: UIView.AnimationOptions) {
        scrollView.contentInset.bottom = 0
    }
    
}

extension SignInVC {
    
    class ViewModel: P_ErrorViewModel {
        
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
        init(_ signInService: P_SignInService, navigateSignUp: @escaping () -> ()) {
            
//            input = Input(
//                email: emailSubject.asObservable(),
//                password: passwordSubject.asObservable(),
//                signInDidTap: signInDidTapSubject.asObserver()
//            )
            
            output = Output(
                signInEnabled: Driver.combineLatest(
                    input.email.asDriver().map { !$0.isEmpty },
                    input.password.asDriver().map { !$0.isEmpty }
                ) { $0 && $1 },
                errors: errorsSubject.asDriver(onErrorJustReturn: NSError(domain: "", code: 0, userInfo: nil))
            )
            
            input.signUpDidTap.bind(onNext: navigateSignUp).disposed(by: disposeBag)
            
            weak var weakSelf: ViewModel! = self
            input.signInDidTap
                .withLatestFrom(credentialsObservable)
                .flatMapLatest { signInService.signIn(with: $0) }
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
