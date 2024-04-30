//
//  SignInQuery.swift
//  UriBoard
//
//  Created by 김재석 on 4/13/24.
//

import Foundation

// 로그인 요청 쿼리
struct SignInQuery: Encodable {
    let email: String
    let password: String
}
