//
//  Router.swift
//  UriBoard
//
//  Created by 김재석 on 4/16/24.
//

import Foundation
import Alamofire

enum Router {
    case auth(router: AuthRouter)
    case post(router: PostRouter)
}

extension Router: TargetType {
    var baseUrl: String {
        switch self {
        case .auth(let router):
            return router.baseUrl
        case .post(let router):
            return router.baseUrl
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .auth(let router):
            return router.method
        case .post(let router):
            return router.method
        }
    }
    
    var path: String {
        switch self {
        case .auth(let router):
            return router.path
        case .post(let router):
            return router.path
        }
    }
    
    var header: [String : String] {
        switch self {
        case .auth(let router):
            return router.header
        case .post(let router):
            return router.header
        }
    }
    
    var parameters: String? {
        switch self {
        case .auth(let router):
            return router.parameters
        case .post(let router):
            return router.parameters
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .auth(let router):
            return router.queryItems
        case .post(let router):
            return router.queryItems
        }
    }
    
    var body: Data? {
        switch self {
        case .auth(let router):
            return router.body
        case .post(let router):
            return router.body
        }
    }

}
