//
//  HomeViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/16/24.
//

import UIKit

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
        
    }
}
