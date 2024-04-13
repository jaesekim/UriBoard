//
//  SignInModel.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import Foundation

// 로그인 성공했을 때 받는 값
struct SignInModel: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}
