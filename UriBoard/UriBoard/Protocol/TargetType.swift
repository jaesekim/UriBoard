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

        var url: String

        if let parameters {
            url = baseUrl + "/\(parameters)"
        } else {
            url = baseUrl
        }
        
        var components = URLComponents(string: url)
        components?.queryItems = queryItems

        let targetURL = try components?.url?.asURL() ?? url.asURL()

        var urlRequest = try URLRequest(
            url: targetURL.appendingPathComponent(path),
            method: method
        )
        
        // header 추가
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpBody = parameters?.data(using: .utf8)
        urlRequest.httpBody = body

        return urlRequest
    }
}
