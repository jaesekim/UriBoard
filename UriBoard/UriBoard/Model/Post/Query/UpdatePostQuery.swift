//
//  UpdatePostQuery.swift
//  UriBoard
//
//  Created by 김재석 on 4/25/24.
//

import Foundation

struct UpdatePostQuery: Encodable {
    let content: String
    let product_id: String
    let files: [String]?
}
