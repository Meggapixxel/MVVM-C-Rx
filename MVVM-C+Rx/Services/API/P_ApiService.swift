//
//  P_ApiManager.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import Alamofire
import RxSwift

protocol P_ApiService {
    
    func setAccessToken(_ accessToken: String?)
    
    func request<T>(
        path: String,
        httpMethod: HTTPMethod,
        parameters: [String : Any]?,
        parametersEncoding: ParameterEncoding,
        headers: HTTPHeaders?,
        decode: @escaping (Data) throws -> T
    ) -> Single<T>
    
    func upload<T>(
        path: String,
        httpMethod: HTTPMethod,
        headers: HTTPHeaders?,
        multipartFormData: @escaping (MultipartFormData) -> Void,
        decode: @escaping (Data) throws -> T
    ) -> Single<T>
    
    func download(fileAtUrl url: URL, destination: @escaping DownloadRequest.Destination, progress: ((Double) -> ())?) -> Single<URL>
    
}

extension P_ApiService {
    
    func request<T: Decodable>(
        path: String,
        httpMethod: HTTPMethod,
        parameters: [String : Any]?,
        parametersEncoding: ParameterEncoding,
        headers: HTTPHeaders?
    ) -> Single<T> {
        request(
            path: path,
            httpMethod: httpMethod,
            parameters: parameters,
            parametersEncoding: parametersEncoding,
            headers: headers,
            decode: { try JSONDecoder().decode(T.self, from: $0) }
        )
    }
    
    func request(
        path: String,
        httpMethod: HTTPMethod,
        parameters: [String : Any]?,
        parametersEncoding: ParameterEncoding,
        headers: HTTPHeaders?
    ) -> Single<Void> {
        request(
            path: path,
            httpMethod: httpMethod,
            parameters: parameters,
            parametersEncoding: parametersEncoding,
            headers: headers,
            decode: { _ in  }
        )
    }
    
    func request(
        path: String,
        httpMethod: HTTPMethod,
        parameters: [String : Any]?,
        parametersEncoding: ParameterEncoding,
        headers: HTTPHeaders?
    ) -> Single<Data> {
        request(
            path: path,
            httpMethod: httpMethod,
            parameters: parameters,
            parametersEncoding: parametersEncoding,
            headers: headers,
            decode: { $0  }
        )
    }
    
}
