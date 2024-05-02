//
//  BoardCollectionViewCell.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit
import SnapKit
import Then

class BoardTableViewCell: UITableViewCell {
    
    let profileImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(systemName: "person")
        $0.tintColor = ColorStyle.lightPurple
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .white
        
    }
    let nicknameLabel = UILabel().then {
        $0.font = FontStyle.getFont(
            scale: .bold,
            size: .small
        )
        $0.numberOfLines = 0
    }
    let contentLabel = UILabel().then {
        $0.font = FontStyle.getFont(
            scale: .regular,
            size: .small
        )
        $0.textColor = ColorStyle.black
        $0.numberOfLines = 0
    }

    let likeButton = CustomButton("heart")
    let commentButton = CustomButton("message")
    let repeatButton = CustomButton("repeat")
    
    let commentTextField = UITextField.addLeftPadding(
        placeholder: "답글을 입력해 주세요"
    ).then {
        $0.font = FontStyle.getFont(
            scale: .regular,
            size: .small
        )
    }
    let sendButton = CustomButton("paperplane")
    let commentLabel = UILabel().then {
        $0.font = FontStyle.getFont(
            scale: .bold,
            size: .small
        )
        $0.textColor = .lightGray
        $0.text = "답글 0개"
        $0.textAlignment = .center
    }
    let likeLabel = UILabel().then {
        $0.font = FontStyle.getFont(
            scale: .bold,
            size: .small
        )
        $0.textColor = .lightGray
        $0.text = "좋아요 0개"
        $0.textAlignment = .center
    }
    let commentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: layout 세팅
extension BoardTableViewCell: UISettings {
    func configureHierarchy() {
        [
            profileImage,
            nicknameLabel,
            contentLabel,
            likeButton,
            commentButton,
            repeatButton,
            commentLabel,
            likeLabel,
            commentStackView
        ].forEach { contentView.addSubview($0) }
        
        [
            commentTextField,
            sendButton,
        ].forEach { commentStackView.addArrangedSubview($0) }
    }
    
    func configureConstraints() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.height.equalTo(20)

        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.height.lessThanOrEqualTo(200)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(nicknameLabel.snp.leading)
        }
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.equalTo(contentLabel.snp.bottom).offset(24)
            make.leading.equalTo(contentLabel.snp.leading)
        }
        commentButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.equalTo(contentLabel.snp.bottom).offset(24)
            make.leading.equalTo(likeButton.snp.trailing).offset(16)
        }
        repeatButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.equalTo(contentLabel.snp.bottom).offset(24)
            make.leading.equalTo(commentButton.snp.trailing).offset(16)
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(commentTextField.snp.bottom).offset(16)
            make.height.equalTo(24)
            make.leading.equalTo(contentLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(contentView.snp.centerX)
        }
        likeLabel.snp.makeConstraints { make in
            make.top.equalTo(commentTextField.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(contentView.safeAreaLayoutGuide).offset(-16)
            make.leading.equalTo(commentLabel.snp.trailing).offset(8)
        }
        commentStackView.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(16)
            make.leading.equalTo(contentLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configureView() {
        contentView.backgroundColor = .clear
    }
}
