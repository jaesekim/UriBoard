//
//  PostViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit

final class PostViewController: BaseViewController {

    let mainView = PostView()
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
