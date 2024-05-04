//
//  LikeRouter.swift
//  UriBoard
//
//  Created by 김재석 on 5/3/24.
//

import Foundation
import Alamofire

enum LikeRouter {
    case postLike(id: String, query: PostLikeQuery)
    case postReboard(id: String, query: PostLikeQuery)
    case readLike(query: LikeQueryString)
    case readReboard(query: LikeQueryString)
}

extension LikeRouter: TargetType {
    var baseUrl: String {
        switch self {
        case
                .postLike,
                .postReboard,
                .readLike,
                .readReboard:
            return APIURL.baseURL + "/v1"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case
                .postLike,
                .postReboard:
            return .post
        case
                .readLike,
                .readReboard:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .postLike(let id, _):
            return "/posts/\(id)/like"
        case .postReboard(let id, _):
            return "/posts/\(id)/like-2"
        case .readLike:
            return "/posts/likes/me"
        case .readReboard:
            return "/posts/likes-2/me"
        }
    }
    
    var header: [String : String] {
        switch self {
        case
                .postLike,
                .postReboard,
                .readLike,
                .readReboard:
            return [
                HTTPHeader.auth.rawValue: UserDefaultsManager.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.key,
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case
                .postLike,
                .postReboard,
                .readLike,
                .readReboard:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .postLike:
            return nil
        case .postReboard:
            return nil
        case .readLike(let query):
            return [
                URLQueryItem(name: "next", value: query.next),
                URLQueryItem(name: "limit", value: query.limit)
            ]
        case .readReboard(let query):
            return [
                URLQueryItem(name: "next", value: query.next),
                URLQueryItem(name: "limit", value: query.limit)
            ]
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        switch self {
        case .postLike(_, let query):
            return try? encoder.encode(query)
        case .postReboard(_, let query):
            return try? encoder.encode(query)
        case .readLike:
            return nil
        case .readReboard:
            return nil
        }
    }
    
    
}
