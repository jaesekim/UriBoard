//
//  SignUpError.swift
//  UriBoard
//
//  Created by 김재석 on 4/22/24.
//

import Foundation

enum SignUpError: Int, Error {
    // 공통
    case keyError = 420
    case overCall = 429
    case invalidURL = 444
    case serverError = 500

    case requiredValue = 400
    case alreadyExist = 409    
}
