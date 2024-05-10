//
//  ProfileQuery.swift
//  UriBoard
//
//  Created by 김재석 on 5/10/24.
//

import Foundation

struct ProfileQuery: Encodable {
    let nick: String
    let profile: Data
}
