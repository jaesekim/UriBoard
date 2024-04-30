//
//  SignUpQuery.swift
//  UriBoard
//
//  Created by 김재석 on 4/13/24.
//

import Foundation

struct SignUpQuery: Encodable {
    let email: String
    let password: String
    let nick: String
}
