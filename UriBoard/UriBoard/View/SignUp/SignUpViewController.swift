//
//  SignUpViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/15/24.
//

import UIKit

final class SignUpViewController: BaseViewController {

    let mainView = SignUpView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}

extension SignUpViewController {
    override func setNavigationBar() {
        navigationItem.title = "회원가입"
    }
}
