//
//  UIButton+Extension.swift
//  UriBoard
//
//  Created by 김재석 on 4/11/24.
//

import UIKit

extension UIButton.Configuration {
    
    static func confirmButton(message: String, color: UIColor?) -> UIButton.Configuration {
        
        var config = UIButton.Configuration.filled()
        
        config.title = message
        config.baseBackgroundColor = color

        return config
    }
}
