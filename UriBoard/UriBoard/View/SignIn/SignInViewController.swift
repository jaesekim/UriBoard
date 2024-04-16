//
//  SignInViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: BaseViewController {

    let mainView = SignInView()

    override func loadView() {
        view = mainView
    }
    
    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension SignInViewController {
    override func setNavigationBar() {
        navigationItem.title = "로그인"
    }
}

extension SignInViewController {

    override func bind() {
        let input = SignInViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty.asObservable(),
            passwordText: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
            signInOnClick: mainView.confirmButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.signInValidation
            .drive(with: self) { owner, bool in
                let color: UIColor = bool ? ColorStyle.darkYellow : ColorStyle.gray

                owner.mainView.confirmButton.configuration = .confirmButton(
                    message: "로그인",
                    color: color
                )
            }
            .disposed(by: disposeBag)
        
        output.signInButtonOnClick
            .drive(with: self) { owner, _ in
                
                let vc = HomeViewController()

                owner.navigationController?.pushViewController(
                    vc,
                    animated: true
                )
            }
            .disposed(by: disposeBag)
    }
}
