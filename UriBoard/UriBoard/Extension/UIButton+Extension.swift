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
    
    static func iconButton(title: String?, systemName: String) -> UIButton.Configuration {
        
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = ColorStyle.lightDark
        config.imagePadding = 8
        config.title = title
        config.image = UIImage(systemName: systemName)
        
        
        return config
    }
    
    static func followingButton(status: Bool) -> UIButton.Configuration {

        var config = UIButton.Configuration.plain()
        if status {  // 팔로우 취소 활성화
            config.baseForegroundColor = ColorStyle.reject
            config.image = UIImage(systemName: "person.badge.minus")
        } else { // 팔로우 추가 활성화
            config.baseForegroundColor = ColorStyle.confirmBlue
            config.image = UIImage(systemName: "person.badge.plus")
        }

        return config
    }
}
