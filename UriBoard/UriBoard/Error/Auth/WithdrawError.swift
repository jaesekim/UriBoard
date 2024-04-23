//
//  WithdrawError.swift
//  UriBoard
//
//  Created by 김재석 on 4/23/24.
//

import Foundation

enum WithdrawError: Int, Error {
    case keyError = 420
    case overCall = 429
    case invalidURL = 444
    case serverError = 500
    
    case invalidToken = 401
    case forbidden = 403
    case expiredToken = 419
}
