//
//  SignInViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import UIKit

final class SignInViewController: BaseViewController {

    let mainView = SignInView()

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func configureHierarchy() {
        print("signin hierarchy")
    }

    override func bind() {
        super.bind()
        print("signin bind")
    }
}
