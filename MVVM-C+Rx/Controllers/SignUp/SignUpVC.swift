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

final class SignUpVC: UIViewController, P_ViewController {
    
    static var initiableResource: InitializableSource { .xib }
    
    // MARK: - P_BaseRx
    let disposeBag = DisposeBag()
    
    // MARK: - UI
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordCofirmTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!

    deinit {
        print("ViewController | \(String(describing: type(of: self)))", #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController | \(String(describing: type(of: self)))", #function)
    }
    
    // MARK: - P_Bindable
    var viewModel: SignUpVM!
    
    func bindViewModel() {
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)
        
        passwordCofirmTextField.rx.text.orEmpty
            .bind(to: viewModel.input.passwordConfirm)
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
