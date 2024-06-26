//
//  PostRouter.swift
//  UriBoard
//
//  Created by 김재석 on 4/23/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case imageUpload
    case createPost(query: CreatePostQuery)
    case readPosts(query: ReadPostsQueryString)
    case readProfileImg(profile: String)
    case readDetailPost(id: String)
    case updatePost(id: String, query: UpdatePostQuery)
    case deletePost(id: String)
    case readUserPosts(id: String, query: ReadUserPostsQueryString)
}

extension PostRouter: TargetType {
    var baseUrl: String {
        switch self {
        case
                .imageUpload,
                .createPost,
                .readPosts,
                .readProfileImg,
                .readDetailPost,
                .updatePost,
                .deletePost,
                .readUserPosts:
            return APIURL.baseURL
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .imageUpload:
            return .post
        case .createPost:
            return .post
        case .readPosts:
            return .get
        case .readProfileImg:
            return .get
        case .readDetailPost:
            return .get
        case .updatePost:
            return .put
        case .deletePost:
            return .delete
        case .readUserPosts:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .imageUpload:
            return "/v1/posts/files"
        case .createPost:
            return "/v1/posts"
        case .readPosts:
            return "/v1/posts"
        case .readProfileImg(let profile):
            return "/v1/" + profile
        case .readDetailPost:
            return "/v1/posts"
        case .updatePost:
            return "/v1/posts"
        case .deletePost:
            return "/v1/posts"
        case .readUserPosts:
            return "/v1/posts/users"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .imageUpload:
            return [
                HTTPHeader.auth.rawValue: UserDefaultsManager.accessToken,
                HTTPHeader.contentType.rawValue: HTTPHeader.multiPart.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.key
            ]
        case 
                .createPost,
                .updatePost:
            return [
                HTTPHeader.auth.rawValue: UserDefaultsManager.accessToken,
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.key
            ]
        case 
                .readPosts,
                .readDetailPost,
                .deletePost,
                .readUserPosts:
            return [
                HTTPHeader.auth.rawValue: UserDefaultsManager.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.key
            ]
        case .readProfileImg:
            return [:]
        }
    }
    
    var parameters: String? {
        switch self {
        case .imageUpload:
            return nil
        case .createPost:
            return nil
        case .readPosts:
            return nil
        case .readProfileImg:
            return nil
        case .readDetailPost(let id):
            return id
        case .updatePost(let id, _):
            return id
        case .deletePost(let id):
            return id
        case .readUserPosts(let id, _):
            return id
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .imageUpload:
            return nil
        case .createPost:
            return nil
        case .readPosts(let query):
            return [
                URLQueryItem(name: "next", value: query.next),
                URLQueryItem(name: "limit", value: query.limit),
                URLQueryItem(name: "product_id", value: query.product_id)
            ]
        case .readProfileImg:
            return nil
        case .readDetailPost:
            return nil
        case .updatePost:
            return nil
        case .deletePost:
            return nil
        case .readUserPosts(let id, let query):
            return [
                URLQueryItem(name: "next", value: query.next),
                URLQueryItem(name: "limit", value: query.limit),
                URLQueryItem(name: "product_id", value: query.product_id)
            ]
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        switch self {
        case .imageUpload:
            return nil
        case .createPost(let query):
            return try? encoder.encode(query)
        case .readPosts:
            return nil
        case .readProfileImg:
            return nil
        case .readDetailPost:
            return nil
        case .updatePost:
            return nil
        case .deletePost:
            return nil
        case .readUserPosts:
            return nil
        }
    }
}
