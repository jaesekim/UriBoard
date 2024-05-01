//
//  HomeViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {

    let mainView = HomeView()
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}


extension HomeViewController {
    override func setNavigationBar() {
        navigationItem.title = "홈"
    }
}

extension HomeViewController {
    override func bind() {
        let items = Observable.just([
            1,
            2,
            3
        ])

        items
            .bind(to: mainView.boardTableView.rx.items(
                cellIdentifier: "BoardTableViewCell",
                cellType: BoardTableViewCell.self)
            ) { (row, element, cell) in
                cell.nicknameLabel.text = "test"
                cell.contentLabel.text = "content test content test content test content test content test content test content test content test content test"
            }
            .disposed(by: disposeBag)
    }
}
