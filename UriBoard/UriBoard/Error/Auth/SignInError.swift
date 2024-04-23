//
//  SignInError.swift
//  UriBoard
//
//  Created by 김재석 on 4/23/24.
//

import Foundation

enum SignInError: Int, Error {
    case keyError = 420
    case overCall = 429
    case invalidURL = 444
    case serverError = 500
    
    case requiredValue = 400
    case noAccount = 401
    
}
