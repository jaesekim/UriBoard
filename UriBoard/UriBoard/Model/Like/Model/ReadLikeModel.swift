//
//  ReadLikeModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/3/24.
//

import Foundation

struct ReadLikeModel: Decodable {
    let data: [ReadDetailPostModel]
    let cursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case cursor = "next_cursor"
    }
}
