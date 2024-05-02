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
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(systemName: "person")
        $0.tintColor = ColorStyle.deepPurple
        $0.backgroundColor = ColorStyle.silver
        $0.clipsToBounds = true
    }
    let nickLabel = UILabel().then {
        $0.font = FontStyle.getFont(
            scale: .regular,
            size: .medium
        )
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
    let contentAddButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.title = "등록"
        config.cornerStyle = .medium
        config.baseBackgroundColor = ColorStyle.confirm
        
        $0.configuration = config
    }
}

extension PostView {
    override func configureHierarchy() {
        [
            profileImage,
            nickLabel,
            boardTextView,
            photoCollectionView,
            contentAddButton,
        ].forEach { addSubview($0) }
    }
    override func configureConstraints() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(44)
        }
        nickLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage.snp.centerY)
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(20)
        }
        boardTextView.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.lessThanOrEqualTo(200)
        }
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(boardTextView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
        contentAddButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-40)
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
