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
    let likeButton = CustomButton(<#T##image: String##String#>)
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
            statusStack,
        ].forEach { contentView.addSubview($0) }
        
        [
        ].forEach { buttonStack.addArrangedSubview($0) }
        
        [
            commentLabel,
            
        ].forEach { statusStack.addArrangedSubview($0) }
    }
    
    func configureConstraints() {
        
    }
    
    func configureView() {
        contentView.backgroundColor = .clear
    }
}
