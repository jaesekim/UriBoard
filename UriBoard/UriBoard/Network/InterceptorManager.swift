//
//  InterceptorManager.swift
//  UriBoard
//
//  Created by 김재석 on 4/25/24.
//

import Foundation
import Alamofire

final class InterceptorManager: RequestInterceptor {
    
    private let retryLimit = 3
    private let retryDelay: TimeInterval = 0.5

    func adapt(
        _ urlRequest: URLRequest,
        for session: Alamofire.Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        
        // accessToken 가져와서 Header에 추가
        let accessToken = UserDefaultsManager.accessToken
        var urlRequest = urlRequest
        urlRequest.setValue(
            accessToken,
            forHTTPHeaderField: HTTPHeader.auth.rawValue
        )
        
    
        completion(.success(urlRequest))
    }
    
    func retry(
        _ request: Alamofire.Request,
        for session: Alamofire.Session,
        dueTo error: any Error,
        completion: @escaping (Alamofire.RetryResult) -> Void
    ) {
        // 419 에러코드 여부 확인. 419 에러가 아니면 재로그인 유도
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 419 else
        {
            completion(.doNotRetryWithError(error))
            return
        }

        // accessToken 재발급 로직
        // 최대 3회 리트라이
        if request.retryCount < retryLimit {
            do {
                let urlRequest = try Router.auth(
                    router: .tokenRefresh
                ).asURLRequest()
                print("interceptor:", urlRequest.url!)
                print(urlRequest.headers)
                AF
                    .request(urlRequest)
                    .validate(statusCode: 200..<300)
                    .responseDecodable(of: TokenRefreshModel.self) { response in
                        switch response.result {
                        case .success(let success):
                            // 토큰 갱신 성공!
                            UserDefaultsManager.accessToken = success.accessToken
                            completion(.retry)
                        case .failure(let failure):
                            // 토큰 갱신 실패... -> 아예 로그인 자체를 다시 해 줘야 한다.
                            // 왜 와이? 토큰 자체가 이상하거나 리프레시 토큰이 만료되었기 때문이다.
                            completion(.doNotRetryWithError(error))
                        }
                    }
            } catch {
                completion(.doNotRetryWithError(error))
            }
        } else {
            completion(.doNotRetry)
        }
        
    }
}
