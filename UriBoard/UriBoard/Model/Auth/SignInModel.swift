//
//  SignInModel.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import Foundation

// 로그인 요청 쿼리
struct SignInQuery: Decodable {
    let email: String
    let password: String
}

// 로그인 성공했을 때 받는 값
struct SignInModel: Decodable {
    let token: String
    let refreshToken: String
}
