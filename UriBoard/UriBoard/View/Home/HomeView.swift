//
//  HomeView.swift
//  UriBoard
//
//  Created by 김재석 on 4/16/24.
//

import UIKit
import SnapKit
import Then
final class HomeView: BaseView {
    
    lazy var boardCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.backgroundColor = .clear
        $0.register(
            BoardCollectionViewCell.self,
            forCellWithReuseIdentifier: "BoardCollectionViewCell"
        )
        
    }
}

extension HomeView {
    override func configureHierarchy() {
        [
            boardCollectionView,
        ].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        boardCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
}

extension HomeView {
    private func createLayout() -> UICollectionViewLayout {
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0)
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 5
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            
            return layout
        }
}
