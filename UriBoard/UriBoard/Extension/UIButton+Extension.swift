//
//  UIButton+Extension.swift
//  UriBoard
//
//  Created by 김재석 on 4/11/24.
//

import UIKit

extension UIButton.Configuration {

    static func confirmButton(message: String, color: UIColor?) -> UIButton.Configuration {

        var container = AttributeContainer()
        container.font = FontStyle.getFont(scale: .regular, size: .small)

        var config = UIButton.Configuration.filled()

        config.attributedTitle = AttributedString(message, attributes: container)
        config.baseBackgroundColor = color
        config.cornerStyle = .large

        return config
    }
}
