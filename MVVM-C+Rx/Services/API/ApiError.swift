//
//  ApiError.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import Foundation

struct ErrorMessage: Decodable, Error, LocalizedError {

    let error: String
    
    var errorDescription: String? { error }

}
enum ApiError: Error, LocalizedError {
    
    case message(ErrorMessage), unauthorized, serverInternalError, other(Error)
    
    var errorDescription: String? { localizedDescription }
    
    var localizedDescription: String {
        switch self {
        case .message(let error):
            return error.error
        case .serverInternalError:
            return "500 Internal Server Error"
        case .unauthorized:
            return "401 UNAUTHORIZED"
        case .other(let error):
            return error.localizedDescription
        }
    }
    
}
