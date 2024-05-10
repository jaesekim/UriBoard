//
//  FollowRouter.swift
//  UriBoard
//
//  Created by 김재석 on 5/11/24.
//

import Foundation
import Alamofire

enum FollowRouter {
    case postFollow(id: String)
    case deleteFollow(id: String)
}

extension FollowRouter: TargetType {
    var baseUrl: String {
        switch self {
        case .postFollow:
            return APIURL.baseURL + "/v1"
        case .deleteFollow:
            return APIURL.baseURL + "/v1"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .postFollow:
            return .post
        case .deleteFollow:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .postFollow(let id):
            return "/follow/\(id)"
        case .deleteFollow(let id):
            return "/follow/\(id)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .postFollow, .deleteFollow:
            return [
                HTTPHeader.auth.rawValue: UserDefaultsManager.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.key
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .postFollow:
            return nil
        case .deleteFollow:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .postFollow:
            return nil
        case .deleteFollow:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .postFollow:
            return nil
        case .deleteFollow:
            return nil
        }
    }
    
    
}
