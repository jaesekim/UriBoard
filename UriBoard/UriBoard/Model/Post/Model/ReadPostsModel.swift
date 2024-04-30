//
//  ReadPostsModel.swift
//  UriBoard
//
//  Created by 김재석 on 4/25/24.
//

import Foundation

struct ReadPostsModel: Decodable {
    let data: [ReadDetailPostModel]
    let cursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case cursor = "next_cursor"
    }
}
