//
//  MainVM.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 10.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import RxSwift

class MainVM: BaseViewModel<MainVM.Input, MainVM.Output>, P_ViewModelViewController {
    
    struct Input {
        let logoutDidTap = PublishSubject<Void>()
    }
    
    struct Output {
        
    }
    
    let errorsSubject = PublishSubject<Error>()
    
    // MARK: - Init
    init(navigateSignIn: @escaping () -> ()) {
        super.init(
            input: Input(),
            output: Output()
        )
        
        input.logoutDidTap.bind(onNext: navigateSignIn).disposed(by: disposeBag)
    }
    
}
