//
//  AuthNetworkManager.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import Foundation
import Alamofire
import RxSwift

class AuthNetworkManager {
    
    static let shared = AuthNetworkManager()

    private init() {}

    func apiCall(query: SignInQuery) -> Single<SignInModel> {

        return Single.create { single in
            do {
                let urlRequest = try AuthRouter.signIn(query: query).asURLRequest()
                AF
                    .request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: SignInModel.self) { response in
                        switch response.result {
                        case .success(let success):
                            single(.success(success))
                        case .failure(let failure):
                            guard let statusCode = response.response?.statusCode else {
                                single(.failure(APIError.invalidURL))
                                return
                            }
                            switch statusCode {
                            case 400:
                                return single(.failure(SignInError.requiredError))
                            case 401:
                                return single(.failure(SignInError.invalidAccount))
                            case 420:
                                return single(.failure(APIError.keyError))
                            case 429:
                                return single(.failure(APIError.overCall))
                            case 444:
                                return single(.failure(APIError.invalidURL))
                            case 500:
                                return single(.failure(APIError.serverError))
                            default:
                                single(.failure(APIError.invalidURL))
                            }
                        }
                    }
            } catch {
                single(.failure(APIError.invalidURL))
            }
            return Disposables.create()
        }
    }
    
    func requestAPI<T: Decodable, R: TargetType>(
        type: T.Type,
        router: R
    ) -> Single<T> {

        return Single.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                AF
                    .request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let success):
                            single(.success(success))
                        case .failure(let failure):
                            guard let statusCode = response.response?.statusCode else {
                                single(.failure(APIError.invalidURL))
                                return
                            }
                            switch statusCode {
                            case 400:
                                return single(.failure(SignInError.requiredError))
                            case 401:
                                return single(.failure(SignInError.invalidAccount))
                            case 420:
                                return single(.failure(APIError.keyError))
                            case 429:
                                return single(.failure(APIError.overCall))
                            case 444:
                                return single(.failure(APIError.invalidURL))
                            case 500:
                                return single(.failure(APIError.serverError))
                            default:
                                single(.failure(APIError.invalidURL))
                            }
                        }
                    }
            } catch {
                single(.failure(APIError.invalidURL))
            }
            return Disposables.create()
        }
    }
    
    func requestAPIResult<T: Decodable, R: TargetType>(
        type: T.Type,
        router: R
    ) -> Single<Result<T, APIError>> {

        return Single.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                AF
                    .request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let success):
                            single(.success(.success(success)))
                        case .failure(let failure):
                            guard let statusCode = response.response?.statusCode else {
                                single(.success(.failure(APIError.invalidURL)))
                                return
                            }
                            
                            let apiError = APIError(rawValue: statusCode) ?? APIError.invalidURL
                            single(.success(.failure(apiError)))
                        }
                    }
            } catch {
                single(.failure(APIError.invalidURL))
            }
            return Disposables.create()
        }
    }
}

extension AuthNetworkManager {
    enum SignInError: Error {
        case requiredError
        case invalidAccount
    }
}
