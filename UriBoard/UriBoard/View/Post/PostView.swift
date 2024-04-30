//
//  PostView.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit
import SnapKit
import Then

final class PostView: BaseView {

    let profileImage = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "person")
        $0.tintColor = ColorStyle.deepPurple
        $0.backgroundColor = ColorStyle.gray
        $0.clipsToBounds = true
    }
    let nickLabel = UILabel().then {
        $0.font = FontStyle.getFont(
            scale: .regular,
            size: .medium
        )
    }
    let photoAddButton = CustomButton("photo.badge.plus")
    let boardTextView = UITextView().then {
        $0.font = FontStyle.getFont(
            scale: .regular,
            size: .medium
        )
    }
}

extension PostView {
    override func configureHierarchy() {
        [
            profileImage,
            nickLabel,
            boardTextView,
            photoAddButton,
        ].forEach { addSubview($0) }
    }
    override func configureConstraints() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(44)
        }
        nickLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(20)
        }
        photoAddButton.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(20)
            make.size.equalTo(24)
//            make.leading.equalToSuperview().offset(16)
            make.centerX.equalTo(profileImage.snp.centerX)
        }
        boardTextView.snp.makeConstraints { make in
            make.top.equalTo(photoAddButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.lessThanOrEqualTo(44)
        }
    
    }
    override func configureView() {
        super.configureView()

        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in

            guard let self = self else { return }
            self.profileImage.layer.cornerRadius = 22
        }
    }
}
