//
//  ProfileRouter.swift
//  UriBoard
//
//  Created by 김재석 on 5/10/24.
//

import Foundation
import Alamofire

enum ProfileRouter {
    case myProfile
    case updateProfile(query: ProfileQuery)
    case otherProfile(userId: String)
}

extension ProfileRouter: TargetType {
    var baseUrl: String {
        switch self {
        case .myProfile:
            return APIURL.baseURL + "/v1"
        case .updateProfile(let query):
            return APIURL.baseURL + "/v1"
        case .otherProfile(let userId):
            return APIURL.baseURL + "/v1"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .myProfile:
            return .get
        case .updateProfile(let query):
            return .put
        case .otherProfile(let userId):
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .myProfile:
            return "/users/me/profile"
        case .updateProfile(let query):
            return "/users/me/profile"
        case .otherProfile(let userId):
            return "/users/\(userId)/profile"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .myProfile, .otherProfile:
            return [
                HTTPHeader.auth.rawValue: UserDefaultsManager.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.key,
            ]
        case .updateProfile:
            return [
                HTTPHeader.auth.rawValue: UserDefaultsManager.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.key,
                HTTPHeader.contentType.rawValue: HTTPHeader.multiPart.rawValue
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .myProfile:
            return nil
        case .updateProfile(let query):
            return nil
        case .otherProfile(let userId):
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .myProfile:
            return nil
        case .updateProfile(let query):
            return nil
        case .otherProfile(let userId):
            return nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        switch self {
        case .myProfile:
            return nil
        case .updateProfile(let query):
            return try? encoder.encode(query)
        case .otherProfile(let userId):
            return nil
        }
    }
    

}
