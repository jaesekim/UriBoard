//
//  PostPhotoCollectionViewCell.swift
//  UriBoard
//
//  Created by 김재석 on 5/2/24.
//

import UIKit
import Then
import SnapKit

class PostPhotoCollectionViewCell: UICollectionViewCell {
 
    let addedPhoto = UIImageView(frame: .zero).then {
        $0.layer.cornerRadius = 4
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "star")
        $0.backgroundColor = ColorStyle.silver
    }
    let deleteButton = UIButton().then {
        $0.setImage(
            UIImage(systemName: "xmark.circle.fill"),
            for: .normal
        )
        $0.tintColor = ColorStyle.reject
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

extension PostPhotoCollectionViewCell: UISettings {
    func configureHierarchy() {
        contentView.addSubview(addedPhoto)
        contentView.addSubview(deleteButton)
    }
    
    func configureConstraints() {
        addedPhoto.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.centerX.centerY.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    func configureView() {
        contentView.backgroundColor = .clear
    }
}
