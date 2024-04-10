//
//  MyProfile.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import Foundation

struct MyProfile: Codable {
    let user_id: String
    let email: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    let followers: [UserSimple]
    let following: [UserSimple]
    let posts: [String]
}

struct UserSimple: Codable {
    let user_id: String
    let nick: String
    let profileImage: String?
}
