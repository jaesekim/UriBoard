//
//  EditProfileView.swift
//  UriBoard
//
//  Created by 김재석 on 5/11/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa
import RxGesture

final class EditProfileView: BaseView {

    let disposeBag = DisposeBag()
    var profileImageCallback: (() -> Void)?
    var deleteImageCallBack: (() -> Void)?
    
    let profileImage = UIImageView(frame: .zero).then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 60
        $0.layer.borderColor = ColorStyle.lightDark.cgColor
        $0.layer.borderWidth = 4
        $0.image = UIImage(named: "profile")
    }
    let cancelImage = UIImageView(
        frame: .zero
    ).then {
        $0.image = UIImage(systemName: "xmark.circle")
        $0.tintColor = ColorStyle.reject
    }
    let nicknameTextField = UITextField.addLeftPadding(
        placeholder: "닉네임을 입력해 주세요"
    )
    let nickGuide = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
        $0.textAlignment = .center
    }
    let confirmButton = UIButton().then {
        $0.configuration = .confirmButton(
            message: "변경하기",
            color: ColorStyle.confirm
        )
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditProfileView {
    
    private func bind() {
        profileImage.rx.tapGesture()
            .when(.recognized)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.profileImageCallback?()
            }
            .disposed(by: disposeBag)
        
        cancelImage.rx.tapGesture()
            .when(.recognized)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.deleteImageCallBack?()
            }
            .disposed(by: disposeBag)
    }
}
// MARK: 레이아웃 잡기
extension EditProfileView {
    override func configureHierarchy() {
        [
            profileImage,
            cancelImage,
            nicknameTextField,
            nickGuide,
            confirmButton,
        ].forEach { addSubview($0) }
    }
    override func configureConstraints() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(120)
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
        }
        cancelImage.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.trailing.equalTo(profileImage.snp.trailing)
            make.bottom.equalTo(profileImage.snp.bottom)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
        nickGuide.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-80)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
    }
}
// MARK: 세부 UI 잡기
extension EditProfileView: KingfisherModifier {
    override func configureView() {
        super.configureView()

        let imgURL = createImgURL(path: UserDefaultsManager.profileImage
        )
        
        profileImage.kf.setImage(
            with: URL(
                string: imgURL
            ),
            placeholder: UIImage(named: "profile"),
            options: [.requestModifier(modifier)]
        )
        nicknameTextField.text = UserDefaultsManager.nickname
    }
    func updateUI() {}
}
