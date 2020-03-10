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

final class SignInVC: UIViewController, P_ViewController {
    
    static var initiableResource: InitializableSource { .storyboard(storyboard: UIStoryboard(name: "Main", bundle: nil)) }
    
    // MARK: - P_BaseRx
    let disposeBag = DisposeBag()
    
    // MARK: - UI
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!

    #if DEBUG
    deinit {
        print("ViewController | \(String(describing: type(of: self)))", #function)
    }
    #endif
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        print("ViewController | \(String(describing: type(of: self)))", #function)
        #endif
    }
    
    // MARK: - P_Bindable
    var viewModel: SignInVM!
    
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
