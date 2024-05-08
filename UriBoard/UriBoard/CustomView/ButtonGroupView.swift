//
//  ButtonGroupView.swift
//  UriBoard
//
//  Created by 김재석 on 5/7/24.
//

import UIKit
import Then
import SnapKit

class ButtonGroupView: BaseView {

    let likeButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.baseForegroundColor = ColorStyle.lightDark
        $0.configuration = config
    }
    let commentButton = UIButton()
    let repeatButton = UIButton().then {
        $0.setImage(
            UIImage(systemName: "repeat.circle"),
            for: .normal
        )
        $0.tintColor = ColorStyle.lightDark
    }
}

extension ButtonGroupView {
    override func configureHierarchy() {
        [
            likeButton,
            commentButton,
            repeatButton
        ].forEach { addSubview($0) }
    }
    override func configureConstraints() {
        likeButton.snp.makeConstraints { make in
            make.leading.top.equalTo(self)
            make.size.equalTo(44)
        }
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.size.equalTo(44)
            make.leading.equalTo(likeButton.snp.trailing).offset(44)
        }
        repeatButton.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.size.equalTo(44)
            make.leading.equalTo(commentButton.snp.trailing).offset(44)
        }
    }
}
