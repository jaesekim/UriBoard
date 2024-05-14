//
//  PaymentsRouter.swift
//  UriBoard
//
//  Created by 김재석 on 5/7/24.
//

import Foundation
import Alamofire

enum PaymentsRouter {
    case validation(query: PaymentsValidationQuery)
    case list
}

extension PaymentsRouter: TargetType {
    var baseUrl: String {
        switch self {
        case .validation:
            return APIURL.baseURL + "/v1"
        case .list:
            return APIURL.baseURL + "/v1"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .validation:
            return .post
        case .list:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .validation:
            return "/payments/validation"
        case .list:
            return "/payments/me"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .validation:
            return [
                HTTPHeader.auth.rawValue: UserDefaultsManager.accessToken,
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.key
            ]
        case .list:
            return [
                HTTPHeader.auth.rawValue: UserDefaultsManager.accessToken,
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.key
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .validation:
            return nil
        case .list:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .validation:
            return nil
        case .list:
            return nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        switch self {
        case .validation(let query):
            print("router:", query)
            return try? encoder.encode(query)
        case .list:
            return nil
        }
    }
    
    
}
