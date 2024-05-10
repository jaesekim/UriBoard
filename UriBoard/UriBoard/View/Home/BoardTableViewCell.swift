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
import RxGesture

class BoardTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    let viewModel = BoardTableViewModel()
    // let passDelegate: PassDataProtocol?
    
    var nicknameGestureClosure: (() -> Void)?
    var likeButtonClosure: (() -> Void)?
    var reboardButtonClosure: (() -> Void)?
    
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
    let lineView = UIView().then {
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1.5
    }
    let imageArea = ImageLayoutView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = ColorStyle.moreLightDark.cgColor
    }
    let buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.spacing = 0
    }
    let likeButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        config.baseForegroundColor = ColorStyle.lightDark
        $0.configuration = config
    }
    let commentButton = UIButton()
    var repeatButton = UIButton().then {
        $0.setImage(
            UIImage(systemName: "repeat.circle"),
            for: .normal
        )
        $0.tintColor = ColorStyle.lightDark
    }
    let totalStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 10
    }
    let bufferView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureConstraints()
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BoardTableViewCell {
    func bind() {
        
        profileImage.rx
            .tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.nicknameGestureClosure?()
            }
            .disposed(by: disposeBag)
        nicknameLabel.rx
            .tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.nicknameGestureClosure?()
            }
            .disposed(by: disposeBag)
        likeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.likeButtonClosure?()
            }
            .disposed(by: disposeBag)
        
        repeatButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.reboardButtonClosure?()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: layout 세팅
extension BoardTableViewCell: UISettings {
    
    func configureHierarchy() {
        [
            likeButton,
            commentButton,
            repeatButton,
        ].forEach { buttonStack.addArrangedSubview($0) }
        [
            imageArea,
            buttonStack
        ].forEach { totalStack.addArrangedSubview($0) }
        [
            profileImage,
            nicknameLabel,
            contentLabel,
            lineView,
            totalStack,
            bufferView,
        ].forEach { contentView.addSubview($0) }
        
    }
    
    func configureConstraints() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(8)
        }
        lineView.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.top.equalTo(profileImage.snp.bottom).offset(12)
            make.centerX.equalTo(profileImage.snp.centerX)
            make.bottom.equalToSuperview().offset(-12)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(profileImage.snp.trailing).offset(12)
            make.height.equalTo(24)
            
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            make.height.lessThanOrEqualTo(200)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(nicknameLabel.snp.leading)
        }
        
//        likeButton.snp.makeConstraints { make in
//            make.width.equalTo(44)
//        }
//        commentButton.snp.makeConstraints { make in
//            make.width.equalTo(44)
//        }
//        repeatButton.snp.makeConstraints { make in
//            make.width.equalTo(44)
//        }
        totalStack.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(32)
            make.leading.equalTo(contentLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-16)
            make.height.lessThanOrEqualTo(254)
//            make.bottom.equalToSuperview().offset(-16)
        }
        imageArea.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        buttonStack.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        bufferView.snp.makeConstraints { make in
            make.top.equalTo(totalStack.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(2)
        }
    }
    
    func configureView() {
        contentView.backgroundColor = .clear
        DispatchQueue.main.async { [weak self] in
            
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
            placeholder: UIImage(named: "profile"),
            options: [.requestModifier(modifier)]
        )
        nicknameLabel.text = element.creator.nick
        contentLabel.text = element.content

        if element.files.isEmpty {
            imageArea.isHidden = true
        } else {
            imageArea.isHidden = false
        }
        imageArea.updateImagesLayout(element.files)
    }
}

// 테이블 뷰 재사용 구독 끊어주기
extension BoardTableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
