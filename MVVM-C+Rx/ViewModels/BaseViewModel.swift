//
//  BaseViewModel.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 10.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import RxSwift

class BaseViewModel<INPUT, OUTPUT>: P_ViewModel {
    
    private static var prefix: String { "ViewModel" }
    
    // MARK: - P_BaseRx
    let disposeBag = DisposeBag()
    
    // MARK: - P_ViewModel
    let input: INPUT
    let output: OUTPUT
    
    #if DEBUG
    deinit {
        print("\(BaseViewModel.prefix) | \(String(describing: self).replacingOccurrences(of: "MVVM_C_Rx.", with: ""))", #function)
    }
    #endif
    
    init(input: INPUT, output: OUTPUT) {
        self.input = input
        self.output = output
        #if DEBUG
        print("\(BaseViewModel.prefix) | \(String(describing: self).replacingOccurrences(of: "MVVM_C_Rx.", with: ""))", #function)
        #endif
    }
    
}
