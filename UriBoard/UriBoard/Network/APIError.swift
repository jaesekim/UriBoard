//
//  APIError.swift
//  UriBoard
//
//  Created by 김재석 on 4/11/24.
//

import Foundation

enum APIError: Int, Error {
    case keyError = 420
    case overCall = 429
    case invalidURL = 444
    case serverError = 500
}
