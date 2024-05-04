//
//  BoardTableViewCell.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa

class BoardTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    let viewModel = BoardTableViewModel()

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
    let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = ColorStyle.black
        $0.numberOfLines = 0
    }
    let likeButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.baseForegroundColor = ColorStyle.pink
        $0.configuration = config
    }
    let commentButton = UIButton()
    var repeatButton = UIButton().then {
        $0.setImage(
            UIImage(systemName: "repeat.circle"),
            for: .normal
        )
        $0.tintColor = ColorStyle.pink
    }

    let imgStackView = UIStackView()
    
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
            imgStackView,
        ].forEach { contentView.addSubview($0) }
    }
    
    func configureConstraints() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(profileImage.snp.trailing).offset(24)
            make.height.equalTo(20)

        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(20)
            make.height.lessThanOrEqualTo(200)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(nicknameLabel.snp.leading)
        }
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.top.equalTo(contentLabel.snp.bottom).offset(32)
            make.leading.equalTo(contentLabel.snp.leading)
        }
        commentButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.top.equalTo(contentLabel.snp.bottom).offset(32)
            make.leading.equalTo(likeButton.snp.trailing).offset(24)
        }
        repeatButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.top.equalTo(contentLabel.snp.bottom).offset(32)
            make.leading.equalTo(commentButton.snp.trailing).offset(24)
        }
        imgStackView.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(24)
            make.leading.equalTo(contentLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureView() {
        contentView.backgroundColor = .clear
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in

            guard let self = self else { return }
            self.profileImage.layer.cornerRadius = 22
        }
    }
}

extension BoardTableViewCell: KingfisherModifier {
    
    func updateUI(_ element: ReadDetailPostModel) {
        
        let imgUrl = APIURL.baseURL + "/v1/" + (element.creator.profileImage ?? "")
        let likeStatus = element.likes.contains(
            UserDefaultsManager.userId
        )
        let reboardStatus = element.likes2.contains(
            UserDefaultsManager.userId
        )
        
        likeButton.configuration = .iconButton(
            title: "\(element.likes.count)",
            systemName: likeStatus ? "heart.fill" : "heart"
        )
        commentButton.configuration = .iconButton(
            title: "\(element.comments.count)",
            systemName: "message"
        )
        repeatButton.configuration = .iconButton(
            title: "\(element.likes2.count)",
            systemName: reboardStatus ? "repeat.circle.fill" : "repeat.circle"
        )

        profileImage.kf.setImage(
            with: URL(string: imgUrl),
            placeholder: UIImage(systemName: "person"),
            options: [.requestModifier(modifier)]
        )
        nicknameLabel.text = element.creator.nick
        contentLabel.text = element.content

        if element.files.isEmpty {
            imgStackView.isHidden = true
        }
    }
}

// 테이블 뷰 재사용 구독 끊어주기
extension BoardTableViewCell {
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}
