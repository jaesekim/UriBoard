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
    
    private let viewModel = SignInViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func setNavigationBar() {
        super.setNavigationBar()

        navigationItem.title = "로그인"
    }
    override func bind() {

        let input = SignInViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty.asObservable(),
            passwordText: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
            signInOnClick: mainView.confirmButton.rx.tap.asObservable(),
            signUpOnClick: mainView.singUpButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.signInValidation
            .drive(with: self) { owner, bool in
                let color: UIColor = bool ? ColorStyle.lightPurple : ColorStyle.gray

                owner.mainView.confirmButton.configuration = .confirmButton(
                    message: "로그인",
                    color: color
                )
                owner.mainView.confirmButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
    
        output.signInGuide
            .drive(mainView.signInGuide.rx.text)
            .disposed(by: disposeBag)
        
        output.signInButtonOnClick
            .drive(with: self) { owner, _ in
                owner.rootViewTransition()
            }
            .disposed(by: disposeBag)
        
        output.signUpbuttonOnClick
            .drive(with: self) { owner, _ in
                owner.navigationController?.pushViewController(
                    SignUpViewController(),
                    animated: true
                )
            }
            .disposed(by: disposeBag)
    }

}

