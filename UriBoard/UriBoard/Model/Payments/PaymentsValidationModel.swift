//
//  PaymentsValidationModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/7/24.
//

import Foundation

struct PaymentsValidationModel: Decodable {
    let imp_uid: String
    let post_id: String
    let productName: String
    let price: Int
}
