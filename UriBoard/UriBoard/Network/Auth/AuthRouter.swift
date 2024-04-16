//
//  AuthRouter.swift
//  UriBoard
//
//  Created by 김재석 on 4/13/24.
//

import Foundation
import Alamofire

enum AuthRouter {
    case signUp(query: SignUpQuery)
    case signIn(query: SignInQuery)
    case tokenRefresh
    case emailValidation(query: EmailValidationQuery)
    case withdraw
}

extension AuthRouter: TargetType {

    var baseUrl: String {
        switch self {
        case 
                .signUp,
                .signIn,
                .tokenRefresh,
                .emailValidation,
                .withdraw:

            return APIURL.baseURL
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signUp:
            return .post
        case .signIn:
            return .post
        case .tokenRefresh:
            return .get
        case .emailValidation:
            return .post
        case .withdraw:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/users/join"
        case .signIn:
            return "/users/login"
        case .tokenRefresh:
            return "/auth/refresh"
        case .emailValidation:
            return "/validation/email"
        case .withdraw:
            return "/users/withdraw"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .signUp, .emailValidation, .signIn:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.key
            ]
        case .tokenRefresh:
            
            guard let accessToken = UserDefaults.standard.string(
                forKey: "AccessToken"
            ) else { return [:] }

            guard let refreshToken = UserDefaults.standard.string(
                forKey: "RefreshToken"
            ) else { return [:] }

            return [
                HTTPHeader.auth.rawValue: accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.key,
                HTTPHeader.refresh.rawValue: refreshToken
            ]
        case .withdraw:
            guard let accessToken = UserDefaults.standard.string(
                forKey: "AccessToken"
            ) else { return [:] }

            return [
                HTTPHeader.auth.rawValue: accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.key
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .signUp:
            return nil
        case .signIn:
            return nil
        case .tokenRefresh:
            return nil
        case .emailValidation:
            return nil
        case .withdraw:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .signUp:
            return nil
        case .signIn:
            return nil
        case .tokenRefresh:
            return nil
        case .emailValidation:
            return nil
        case .withdraw:
            return nil
        }
    }
    
    var body: Data? {

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        switch self {
        case .signUp(let query):
            return try? encoder.encode(query)
        case .signIn(let query):
            return try? encoder.encode(query)
        case .tokenRefresh:
            return nil
        case .emailValidation(let query):
            return try? encoder.encode(query)
        case .withdraw:
            return nil
        }
    }
}
