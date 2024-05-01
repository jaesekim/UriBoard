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
    let photoAddButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "photo.badge.plus")
        config.cornerStyle = .medium
        config.baseForegroundColor = .lightGray
        config.baseBackgroundColor = .systemGray6
        
        $0.configuration = config
    }
    let boardTextView = UITextView().then {
        $0.font = FontStyle.getFont(
            scale: .regular,
            size: .medium
        )
        $0.layer.borderWidth = 0.8
        $0.layer.borderColor = ColorStyle.deepPurple.cgColor
        $0.layer.cornerRadius = 12
    }
    lazy var photoCollectionView = UICollectionView(
        frame: .zero, 
        collectionViewLayout: createLayout()
    ).then {
        $0.register(
            PostPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: "PostPhotoCollectionViewCell"
        )
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
    }
}

extension PostView {
    override func configureHierarchy() {
        [
            profileImage,
            nickLabel,
            boardTextView,
            photoAddButton,
            photoCollectionView,
        ].forEach { addSubview($0) }
    }
    override func configureConstraints() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(44)
        }
        nickLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(20)
        }
        boardTextView.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.lessThanOrEqualTo(200)
        }
        photoAddButton.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(photoCollectionView.snp.centerY)
        }
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(boardTextView.snp.bottom).offset(40)
            make.leading.equalTo(photoAddButton.snp.trailing).offset(20)
            make.height.equalTo(120)
            make.trailing.equalToSuperview().offset(-16)
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

extension PostView {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: 120,
            height: 120
        )
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal

        return layout
    }
}
