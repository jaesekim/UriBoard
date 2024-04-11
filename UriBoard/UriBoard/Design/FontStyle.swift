//
//  Font.swift
//  UriBoard
//
//  Created by 김재석 on 4/11/24.
//

import UIKit

enum FontStyle {

    enum FontSize: CGFloat {
        case small = 13
        case medium = 17
        case large = 22
    }

    enum FontWeight: String {
        case bold = "Bold"
        case regular = "Regular"
    }

    static func getFont(scale: FontWeight, size: FontSize) -> UIFont {
        
        guard let font = UIFont(
            name: "런드리고딕 \(scale)",
            size: size.rawValue
        ) else {
            return .boldSystemFont(ofSize: size.rawValue)
        }

        return font
    }
}

