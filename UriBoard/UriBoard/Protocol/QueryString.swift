//
//  QueryString.swift
//  UriBoard
//
//  Created by 김재석 on 4/24/24.
//

import Foundation

protocol QueryString {
    var next: String { get }
    var limit: String { get }
    var product_id: String { get }
    var hashTag: String { get }
}

extension QueryString {
    var next: String {
        return ""
    }
    
    var limit: String {
        return ""
    }
    
    var product_id: String {
        return ""
    }
    
    var hashTag: String {
        return ""
    }
}

