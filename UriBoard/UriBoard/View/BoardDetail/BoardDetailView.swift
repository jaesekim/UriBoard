//
//  BoardDetailView.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class BoardDetailView: BaseView {
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    let contentView = UIView()
    
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
    let imageArea = ImageLayoutView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
    }
    let likeButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.baseForegroundColor = ColorStyle.pink
        $0.configuration = config
    }
    let commentButton = UIButton()
    let repeatButton = UIButton().then {
        $0.setImage(
            UIImage(systemName: "repeat.circle"),
            for: .normal
        )
        $0.tintColor = ColorStyle.pink
    }
    let buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 20
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentViewHierarchy()
        contentViewConstraints()
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension BoardDetailView {
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    override func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    override func configureView() {
        super.configureView()
        
    }
}
// MARK: contentView내 레이아웃 설정
extension BoardDetailView {
    private func contentViewHierarchy() {
        [
            profileImage,
            nicknameLabel,
            contentLabel,
            imageArea,
            buttonStack,
        ].forEach { contentView.addSubview($0) }
        
        [
            likeButton,
            commentButton,
            repeatButton,
        ].forEach { buttonStack.addArrangedSubview($0) }
    }
    private func contentViewConstraints() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(28)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(profileImage.snp.trailing).offset(24)
            make.height.equalTo(44)
            
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.height.greaterThanOrEqualTo(24)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(nicknameLabel.snp.leading)
        }
        imageArea.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.lessThanOrEqualTo(220)
        }
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(imageArea.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(contentView).inset(20)
            make.height.equalTo(44)
        }
    }
    private func configureContentView() {
        contentView.backgroundColor = .clear
        DispatchQueue.main.async() { [weak self] in
            guard let self = self else { return }
            self.profileImage.layer.cornerRadius = 30
        }
    }
}
// MARK: UI 세부 세팅
extension BoardDetailView: KingfisherModifier {

    func updateUI(_ element: ReadDetailPostModel) {

        let imgUrl = APIURL.baseURL + "/v1/" + (element.creator.profileImage ?? "")

        let likeStatus = element.likes.contains(
            UserDefaultsManager.userId
        )
        let reboardStatus = element.likes2.contains(
            UserDefaultsManager.userId
        )

        profileImage.kf.setImage(
            with: URL(string: imgUrl),
            placeholder: UIImage(systemName: "person"),
            options: [.requestModifier(modifier)])
        nicknameLabel.text = element.creator.nick
        contentLabel.text = element.content
        
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

        if element.files.isEmpty {
            imageArea.isHidden = true
        } else {
            imageArea.isHidden = false
        }
        imageArea.updateImagesLayout(element.files)
    }
}
