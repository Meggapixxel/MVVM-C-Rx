//
//  MainVC.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 10.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import UIKit
import RxSwift

class MainVC: UIViewController, P_ViewController {

    static var initiableResource: InitializableSource { .manual }
    
    // MARK: - P_BaseRx
    let disposeBag = DisposeBag()

    #if DEBUG
    deinit {
        print("ViewController | \(String(describing: type(of: self)))", #function)
    }
    #endif
    
    private let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        print("ViewController | \(String(describing: type(of: self)))", #function)
        #endif
        
        view.backgroundColor = .systemBackground
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        button.setTitle("Log out", for: .normal)
    }

    // MARK: - P_Bindable
    var viewModel: MainVM!
    
    func bindViewModel() {
        button.rx.tap
            .bind(to: viewModel.input.logoutDidTap)
            .disposed(by: disposeBag)
    }
        
}
