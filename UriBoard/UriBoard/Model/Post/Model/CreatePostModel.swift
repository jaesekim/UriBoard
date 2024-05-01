//
//  CreatePostModel.swift
//  UriBoard
//
//  Created by 김재석 on 4/25/24.
//

import Foundation

struct CreatePostModel: Decodable {
    let post_id: String
    let product_id: String
    let createdAt: String
    let content: String
    let creator: PostCreator
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let hashTags: [String]
    let comments: [String]
}

struct PostCreator: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String?
}
