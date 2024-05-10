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

final class EditProfileView: BaseView {

    let profileImage = UIImageView(frame: .zero).then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 60
        $0.layer.borderColor = ColorStyle.lightDark.cgColor
        $0.layer.borderWidth = 4
    }
    let nicknameTextField = UITextField.addLeftPadding(
        placeholder: "닉네임을 입력해 주세요"
    )
    let nickGuide = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
        $0.textAlignment = .center
    }
    let confirmButton = UIButton().then {
        $0.setTitle("변경하기", for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = ColorStyle.confirm
    }

}

extension EditProfileView {
    override func configureHierarchy() {
        [
            profileImage,
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

extension EditProfileView: KingfisherModifier {
    override func configureView() {
        super.configureView()

        profileImage.kf.setImage(
            with: URL(
                string: UserDefaultsManager.profileImage
            ),
            placeholder: UIImage(named: "profile"),
            options: [.requestModifier(modifier)]
        )
        nicknameTextField.text = UserDefaultsManager.nickname
    }
    func updateUI() {}
}
