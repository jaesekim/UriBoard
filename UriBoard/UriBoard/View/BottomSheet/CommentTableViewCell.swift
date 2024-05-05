//
//  CommentTableViewCell.swift
//  UriBoard
//
//  Created by 김재석 on 5/4/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then
import RxSwift
import RxCocoa

class CommentTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()

    let profileImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(systemName: "person")
        $0.tintColor = ColorStyle.lightPurple
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        
    }
    let nicknameLabel = UILabel().then {
        $0.font = FontStyle.getFont(
            scale: .bold,
            size: .medium
        )
        $0.numberOfLines = 0
    }
    let commentHandleButton = UIButton().then {
        $0.configuration = .iconButton(
            title: nil,
            systemName: "ellipsis"
        )
    }
    let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = ColorStyle.black
        $0.numberOfLines = 0
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

extension CommentTableViewCell: KingfisherModifier {
    func updateUI(_ element: CommentModel) {
        
        let imgUrl = APIURL.baseURL + "/v1/" + (element.creator.profileImage ?? "")
        profileImage.kf.setImage(
            with: URL(string: imgUrl),
            placeholder: UIImage(systemName: "person"),
            options: [.requestModifier(modifier)]
        )
        nicknameLabel.text = element.creator.nick
        contentLabel.text = element.content

        if element.creator.user_id == UserDefaultsManager.userId {
            commentHandleButton.isHidden = false
        } else {
            commentHandleButton.isHidden = true
        }
    }
}

extension CommentTableViewCell: UISettings {
    func configureHierarchy() {
        [
            profileImage,
            nicknameLabel,
            contentLabel,
            commentHandleButton,
        ].forEach { contentView.addSubview($0) }
    }
    func configureConstraints() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(commentHandleButton.snp.leading).offset(-8)
            make.leading.equalTo(profileImage.snp.trailing).offset(24)
            make.height.lessThanOrEqualTo(44)

        }
        commentHandleButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.size.equalTo(20)
            make.trailing.equalToSuperview().offset(-16)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(nicknameLabel.snp.leading)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    func configureView() {

        contentView.backgroundColor = .clear
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else { return }
            self.profileImage.layer.cornerRadius = 20
        }
        
    }
}

// 테이블 뷰 재사용 구독 끊기
extension CommentTableViewCell {
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}
