//
//  TargetType.swift
//  UriBoard
//
//  Created by 김재석 on 4/13/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    
    var baseUrl: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var header: [String: String] { get }
    var parameters: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {

    func asURLRequest() throws -> URLRequest {
        
        let url = try baseUrl.asURL()
        var urlRequest = try URLRequest(
            url: url.appendingPathComponent(path),
            method: method
        )
        
        // header 추가
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpBody = parameters?.data(using: .utf8)
        urlRequest.httpBody = body
        
        return urlRequest
    }
}
