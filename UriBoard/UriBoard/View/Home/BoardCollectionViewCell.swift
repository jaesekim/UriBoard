//
//  BoardCollectionViewCell.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit
import SnapKit
import Then

class BoardCollectionViewCell: UICollectionViewCell {
    
    let profileImage = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
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
        $0.textColor = ColorStyle.gray
        $0.numberOfLines = 0
    }
    // 게시글에 누를 수 있는 버튼 보여주는 스택 뷰
    let buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
    }
    let likeButton = CustomButton("heart")
    let commentButton = CustomButton("message")
    let repeatButton = CustomButton("repeat")
    
    let commentTextField = UITextField.addLeftImage(
        image: "bubble.right.pulse",
        placeholder: "답글을 입력해 주세요"
    ).then {
        $0.font = FontStyle.getFont(
            scale: .regular,
            size: .small
        )
    }
    let sendButton = CustomButton("paperplane.bounce")
    // 댓글, 좋아요 개수 보여주는 스택 뷰
    let statusStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
    }
    let commentLabel = UILabel().then {
        $0.font = FontStyle.getFont(
            scale: .regular,
            size: .small
        )
        $0.textColor = ColorStyle.gray
    }
    let likeLabel = UILabel().then {
        $0.font = FontStyle.getFont(
            scale: .regular,
            size: .small
        )
        $0.textColor = ColorStyle.gray
    }
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

// MARK: layout 세팅
extension BoardCollectionViewCell: UISettings {
    func configureHierarchy() {
        [
            profileImage,
            nicknameLabel,
            contentLabel,
            buttonStack,
            commentTextField,
            statusStack,
        ].forEach { contentView.addSubview($0) }
        
        [
            likeButton,
            commentButton,
            repeatButton,
        ].forEach { buttonStack.addArrangedSubview($0) }
        
        [
            commentLabel,
            likeLabel,
            
        ].forEach { statusStack.addArrangedSubview($0) }
    }
    
    func configureConstraints() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.top.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.top)
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.height.lessThanOrEqualTo(120)
            make.left.equalTo(nicknameLabel.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentLabel.snp.leading)
            make.height.equalTo(40)
            make.trailing.lessThanOrEqualTo(sendButton.snp.leading)
        }
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.equalTo(buttonStack.snp.top)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        statusStack.snp.makeConstraints { make in
            if buttonStack.isHidden {
                make.top.equalTo(contentLabel.snp.bottom).offset(8)
            } else {
                make.top.equalTo(buttonStack.snp.bottom).offset(8)
            }
            make.leading.equalTo(contentLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(contentView.snp.trailing)
            make.height.equalTo(20)
        }
    }
    
    func configureView() {
        contentView.backgroundColor = .clear
    }
}
