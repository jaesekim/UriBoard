//
//  CreatePostQuery.swift
//  UriBoard
//
//  Created by 김재석 on 4/25/24.
//

import Foundation

struct CreatePostQuery: Encodable {
    let content: String
    let product_id = "uriBoard"
    let files: [String]
}
