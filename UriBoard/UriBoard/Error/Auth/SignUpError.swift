//
//  SignUpError.swift
//  UriBoard
//
//  Created by 김재석 on 4/22/24.
//

import Foundation

enum SignUpError: Int, Error {
    case requiredValue = 400
    case alreadyExist = 409    
}
