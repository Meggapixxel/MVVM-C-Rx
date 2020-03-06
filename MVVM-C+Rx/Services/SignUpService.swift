//
//  SignUpService.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import RxSwift

protocol P_SignUpService {
    
    func signUp(with credentials: Credentials) -> Single<User>
    
}

class SignUpService: P_SignUpService {
    
    let apiSevrice: P_ApiService
    
    init(apiSevrice: P_ApiService) {
        self.apiSevrice = apiSevrice
    }
    
//    func signUp(with credentials: Credentials) -> Single<User> {
//        apiSevrice.request(
//            path: "",
//            httpMethod: .post,
//            parameters: nil,
//            parametersEncoding: JSONEncoding.default,
//            headers: nil,
//            decode: { _ in User() }
//        )
//    }
    
    func signUp(with credentials: Credentials) -> Single<User> {
        Single.create { observer in

            /*
             Networking logic here.
             */

            observer(.success(User()))
            return Disposables.create()
        }
    }
    
}
