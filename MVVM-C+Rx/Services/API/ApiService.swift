//
//  ApiService.swift
//  MVVM-C+Rx
//
//  Created by Vadim Zhydenko on 06.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import Alamofire
import RxSwift

class ApiService: NSObject, P_ApiService {
    
    private let baseUrl: URL
    private let configuration: URLSessionConfiguration
    private let interceptor: AccessTokenAdapter
    private let session: Session
    private let disposeBag = DisposeBag()
    
    init(baseUrl: URL, accessToken: String? = nil, configuration: URLSessionConfiguration = URLSessionConfiguration.af.default) {
        self.baseUrl = baseUrl
        self.configuration = configuration
        self.interceptor = AccessTokenAdapter(url: baseUrl, accessToken: accessToken)
        self.session = Session(configuration: configuration, interceptor: interceptor)
        
        super.init()
        
    }
    
    func setAccessToken(_ accessToken: String?) {
        interceptor.accessToken = accessToken
    }
    
    func request<T>(
        path: String,
        httpMethod: HTTPMethod,
        parameters: [String : Any]?,
        parametersEncoding: ParameterEncoding,
        headers: HTTPHeaders?,
        decode: @escaping (Data) throws -> T
    ) -> Single<T> {
        let request = session.request(
            baseUrl.appendingPathComponent(path),
            method: httpMethod,
            parameters: parameters,
            encoding: parametersEncoding,
            headers: headers
        )
        return Single<T>.create { observer in
            request.response {
                observer(ApiService.commonResponseHandler(response: $0, decode: decode))
            }
            return Disposables.create { request.cancel() }
        }
    }
    
    func upload<T>(
        path: String,
        httpMethod: HTTPMethod,
        headers: HTTPHeaders?,
        multipartFormData: @escaping (MultipartFormData) -> Void,
        decode: @escaping (Data) throws -> T
    ) -> Single<T> {
        let request = session.upload(
            multipartFormData: multipartFormData,
            to: baseUrl.appendingPathComponent(path),
            method: httpMethod,
            headers: headers
        )
        return Single<T>.create { observer in
            request.response {
                observer(ApiService.commonResponseHandler(response: $0, decode: decode))
            }
            return Disposables.create { request.cancel() }
        }
    }
    
    func download(fileAtUrl url: URL, destination: @escaping DownloadRequest.Destination, progress: ((Double) -> ())?) -> Single<URL> {
        Single<URL>.create { observer in
            let request = self.session.download(url, to: destination)
                .downloadProgress { progress?($0.fractionCompleted) }
                .response { response in
                    switch response.result {
                    case .success(let tempFileUrl):
                        // TODO: - remove force unwrap
                        observer(.success(tempFileUrl!))
                    case .failure(let error):
                        observer(.error(ApiError.other(error)))
                    }
                }
            return Disposables.create { request.cancel() }
        }
    }
    
}

extension ApiService {
    
    private static func commonResponseHandler<T>(response: AFDataResponse<Data?>, decode: (Data) throws -> T) -> SingleEvent<T> {
        switch response.result {
        case .success(let data):
            let responseData = data ?? Data()
            let statusCode = response.response?.statusCode ?? 500
            if (200..<300) ~= statusCode {
                do {
                    return .success(try decode(responseData))
                } catch {
                    return .error(ApiError.other(error))
                }
            } else if (401) == statusCode {
                return .error(ApiError.unauthorized)
            } else if (500) == statusCode {
                return .error(ApiError.serverInternalError)
            } else {
                do {
                    return .error(ApiError.message(try JSONDecoder().decode(ErrorMessage.self, from: responseData)))
                } catch {
                    return .error(ApiError.other(error))
                }
            }
        case .failure(let error):
            return .error(ApiError.other(error))
        }
    }
    
}

class AccessTokenAdapter: RequestInterceptor {
    
    private let url: URL
    var accessToken: String?

    init(url: URL, accessToken: String?) {
        self.url = url
        self.accessToken = accessToken
    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let accessToken = accessToken, urlRequest.url?.absoluteString.hasPrefix(url.absoluteString) ?? false {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }
    
}
