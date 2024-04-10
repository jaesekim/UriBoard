//
//  BaseView.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseView: UISettings {
    
    @objc func configureHierarchy() {}
    @objc func configureConstraints() {}
    @objc func configureView() {
        backgroundColor = .white
    }
}
