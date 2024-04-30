//
//  SignUpModel.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import Foundation

struct SignUpModel: Decodable {
    let id: String
    let email: String
    let nick: String

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email
        case nick
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.nick = try container.decode(String.self, forKey: .nick)
    }
}
