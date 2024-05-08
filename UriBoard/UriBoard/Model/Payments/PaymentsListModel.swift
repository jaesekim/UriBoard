//
//  PaymentsListModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/7/24.
//

import Foundation

struct PaymentsListModel: Decodable {
    let data: [PaymentsDetailModel]
}

struct PaymentsDetailModel: Decodable {
    let payment_id: String
    let buyer_id: String
    let post_id: String
    let merchant_uid: String
    let productName: String
    let price: Int
    let paidAt: String
}
