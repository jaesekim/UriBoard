//
//  TextButton.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit

class TextButton: UIButton {

    init(text: String, color: UIColor?) {
        super.init(frame: .zero)
        
        configureView(text, color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TextButton {
    private func configureView(
        _ text: String,
        _ color: UIColor?
    ) {
        
        var config = UIButton.Configuration.plain()
        
        config.title = text
        config.baseForegroundColor = color
        
        self.configuration = config
    }
}
