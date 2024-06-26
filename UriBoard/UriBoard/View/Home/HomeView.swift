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
    
    lazy var boardTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(
            BoardTableViewCell.self,
            forCellReuseIdentifier: "BoardTableViewCell"
        )
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 468
    }
}

extension HomeView {
    override func configureHierarchy() {
        [
            boardTableView,
        ].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        boardTableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
}
