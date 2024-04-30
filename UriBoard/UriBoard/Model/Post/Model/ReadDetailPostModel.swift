//
//  ReadDetailPostModel.swift
//  UriBoard
//
//  Created by 김재석 on 4/25/24.
//

import Foundation

struct ReadDetailPostModel: Decodable {
    let id: String
    let productId: String
    let content: String
    let createdAt: String
    let creator: PostCreator
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let comments: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case productId = "product_id"
        case content, 
             createdAt,
             creator,
             files,
             likes,
             likes2,
             hashTags, 
             comments
    }
}
