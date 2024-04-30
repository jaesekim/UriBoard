//
//  CustomButton.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit

class CustomButton: UIButton {

    init(_ image: String) {
        super.init(frame: .zero)
        
        configureView(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Button 디자인
extension CustomButton {
    private func configureView(image: String) {
        var config = UIButton.Configuration.plain()
        
        config.baseForegroundColor = ColorStyle.lightPurple
        config.image = UIImage(systemName: image)

        self.configuration = config
    }
}
