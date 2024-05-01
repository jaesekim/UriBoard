//
//  ReadUserPostsQueryString.swift
//  UriBoard
//
//  Created by 김재석 on 4/24/24.
//

import Foundation

struct ReadUserPostsQueryString: QueryString {
    let next: String
    let limit: String
    let product_id = "uriBoard"
}
