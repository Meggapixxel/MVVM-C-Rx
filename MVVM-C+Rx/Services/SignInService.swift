//
//  SignInService.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

struct Credentials {
    
    let email: String
    let password: String
    
}

protocol P_SignInService {
    
    func signIn(with credentials: Credentials) -> Single<User>
    func signUp(with credentials: Credentials) -> Single<User>
    
}

class SignInService: P_SignInService {
    
    let apiSevrice: P_ApiService
    
    init(apiSevrice: P_ApiService) {
        self.apiSevrice = apiSevrice
    }
    
//    func signIn(with credentials: Credentials) -> Single<User> {
//        apiSevrice.request(
//            path: "",
//            httpMethod: .get,
//            parameters: nil,
//            parametersEncoding: URLEncoding.default,
//            headers: nil,
//            decode: { _ in User() }
//        )
//    }
    
    // Simulation of successful user authentication.
    func signIn(with credentials: Credentials) -> Single<User> {
        Single.create { observer in

            /*
             Networking logic here.
             */

            observer(.success(User()))
            return Disposables.create()
        }
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
