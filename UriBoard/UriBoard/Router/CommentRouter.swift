//
//  CommentRouter.swift
//  UriBoard
//
//  Created by 김재석 on 5/4/24.
//

import Foundation
import Alamofire

enum CommentRouter {
    case postComment(query: CommentQuery, postId: String)
    case updateComment(query: CommentQuery, postId: String, commentId: String)
    case deleteComment(postId: String, commentId: String)
}

extension CommentRouter: TargetType {
    var baseUrl: String {
        switch self {
            case
                .postComment,
                .updateComment,
                .deleteComment:
            return APIURL.baseURL + "/v1"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .postComment:
            return .post
        case .updateComment:
            return .put
        case .deleteComment:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .postComment(_, let postId):
            return "/posts/\(postId)/comments"
        case .updateComment(_, let postId, let commentId):
            return "/posts/\(postId)/comments/\(commentId)"
        case .deleteComment(let postId, let commentId):
            return "/posts/\(postId)/comments/\(commentId)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .postComment, .updateComment:
            return [
                HTTPHeader.auth.rawValue: UserDefaultsManager.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.key,
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue
            ]
        case .deleteComment:
            return [
                HTTPHeader.auth.rawValue: UserDefaultsManager.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKey.key
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .postComment:
            return nil
        case .updateComment:
            return nil
        case .deleteComment:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case
                .postComment,
                .updateComment,
                .deleteComment:
            return nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        switch self {
        case .postComment(let query, _):
            return try? encoder.encode(query)
        case .updateComment(let query, _, _):
            return try? encoder.encode(query)
        case .deleteComment:
            return nil
        }
    }
}
