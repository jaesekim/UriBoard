//
//  NetworkManager.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    typealias requestType<T: Decodable> = Single<Result<T, APIError>>
    
}

// MARK: AlamoFire API 통신
extension NetworkManager {
    
    func requestAPIResult<T: Decodable, R: TargetType>(
        type: T.Type,
        router: R
    ) -> requestType<T> {
        
        return Single.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                
                AF
                    .request(
                        urlRequest,
                        interceptor: InterceptorManager()
                    )
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let success):
                            single(.success(.success(success)))
                        case .failure(let failure):
                            print(failure)
                            guard let statusCode = response.response?.statusCode else {
                                single(.success(.failure(APIError.serverError)))
                                return
                            }
                            
                            let errorCode = APIError(
                                rawValue: statusCode
                            ) ?? APIError.serverError

                            single(.success(.failure(errorCode)))
                        }
                    }
            } catch {
                single(.success(.failure(APIError.serverError)))
            }
            return Disposables.create()
        }
    }
}

// 이미지 업로드
extension NetworkManager {
    func uploadFiles<T: Decodable, R: TargetType>(
        type: T.Type,
        router: R,
        imgData: [Data]
    ) -> Single<Result<T, APIError>> {
        return Single.create { single -> Disposable in

            do {
                let urlRequest = try router.asURLRequest()

                AF.upload(
                    multipartFormData: { multipartFormData in
                        imgData.forEach {
                            print($0)
                            multipartFormData.append(
                                $0,
                                withName: "files",
                                fileName: "\($0).jpg",
                                mimeType: "image/jpg")
                        }
                    },
                    with: urlRequest,
                    interceptor: InterceptorManager()
                )
                .validate(statusCode: 200..<300)
                .responseDecodable(of: type) { response in
                    switch response.result {
                    case .success(let success):
                        single(.success(.success(success)))
                    case .failure(let failure):
                        print(failure)
                        guard let statusCode = response.response?.statusCode else {
                            return single(.success(.failure(.serverError)))
                        }
                        let errorCode = APIError(
                            rawValue: statusCode
                        ) ?? APIError.serverError

                        single(.success(.failure(errorCode)))
                    }
                }
            } catch {
                single(.success(.failure(.serverError)))
            }
            return Disposables.create()
        }
    }
}

// MARK: Token Refresh
extension NetworkManager {
    
}
