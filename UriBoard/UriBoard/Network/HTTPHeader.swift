//
//  HttpHeader.swift
//  UriBoard
//
//  Created by 김재석 on 4/13/24.
//

import Foundation

enum HTTPHeader: String {
    case contentType = "Content-Type"
    case json = "application/json"
    case multiPart = "multipart/form-data"
    case sesacKey =  "SesacKey"
    case auth = "Authorization"
    case refresh = "Refresh"
}
