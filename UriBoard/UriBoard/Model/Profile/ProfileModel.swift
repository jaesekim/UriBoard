//
//  ProfileModel.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import Foundation

struct ProfileModel: Codable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let followers: [UserInfo]
    let following: [UserInfo]
    let posts: [String]
}

struct UserInfo: Codable {
    let user_id: String
    let nick: String
    let profileImage: String?
}
