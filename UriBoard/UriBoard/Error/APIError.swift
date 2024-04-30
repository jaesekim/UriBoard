//
//  APIError.swift
//  UriBoard
//
//  Created by 김재석 on 4/11/24.
//

import Foundation

enum APIError: Int, Error {
    // 공통 에러코드
    case keyError = 420
    case overCall = 429
    case invalidURL = 444
    case serverError = 500
    
    // 개별 에러코드
    case invalidRequest = 400
    case invalidAccess = 401
    case forbidden = 403
    case invalidAccount = 409
    case noData = 410
    case expiredRefresh = 418
    case expiredAccess = 419
    case authorityError = 445
}
