//
//  UITextField+Extension.swift
//  UriBoard
//
//  Created by 김재석 on 4/11/24.
//

import UIKit

extension UITextField {
    
    static func addLeftPadding(placeholder: String) -> UITextField {
        
        let view = UITextField()
        
        let paddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: 20, height: view.frame.height)
        )
        view.leftView = paddingView
        view.leftViewMode = .always
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorStyle.darkYellow.cgColor
        view.placeholder = placeholder

        return view
    }
    
    static func addLeftImage(
        image: String,
        placeholder: String
    ) -> UITextField {
        
        let view = UITextField()
        
        let leftImage = UIView(
            frame: CGRect(x: 0, y: 0, width: view.frame.height, height: view.frame.height)
        )
        
        view.leftView = leftImage
        view.leftViewMode = .always
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorStyle.darkYellow.cgColor
        view.placeholder = placeholder

        return view
    }
}
