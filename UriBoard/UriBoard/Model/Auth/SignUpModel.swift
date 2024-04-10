//
//  SignUpModel.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import Foundation

struct SignUpModel: Encodable {
    let user_id: String
    let email: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
}
