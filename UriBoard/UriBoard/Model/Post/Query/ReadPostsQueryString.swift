//
//  ReadPostsQueryString.swift
//  UriBoard
//
//  Created by 김재석 on 4/24/24.
//

import Foundation

struct ReadPostsQueryString: QueryString {
    let next: String
    let limit: String
    let product_id = "uriBoard"
}
