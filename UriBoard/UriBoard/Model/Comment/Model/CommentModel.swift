//
//  CommentModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/4/24.
//

import Foundation

struct CommentModel: Decodable {
    let comment_id : String
    let content: String
    let createdAt: String
    let creator: PostCreator
}
