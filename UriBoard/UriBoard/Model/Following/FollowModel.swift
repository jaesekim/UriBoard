//
//  FollowModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/11/24.
//

import Foundation

struct FollowModel: Decodable {
    let nick: String
    let opponent: String
    let status: Bool
    
    enum CodingKeys: String, CodingKey {
        case nick
        case opponent = "opponent_nick"
        case status = "following_status"
    }
}
