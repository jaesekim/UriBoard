//
//  SearchViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/19/24.
//

import UIKit

final class SearchViewController: BaseViewController {

    let mainView = SearchView()
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

}

extension SearchViewController {
    override func setNavigationBar() {
        super.setNavigationBar()
    }
}
