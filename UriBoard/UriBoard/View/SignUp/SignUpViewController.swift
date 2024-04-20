//
//  SignUpViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {

    let mainView = SignUpView()
    
    override func loadView() {
        view = mainView
    }
    
    private let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}

extension SignUpViewController {
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.title = "회원가입"
    }
}
// MARK: bind ViewModel
extension SignUpViewController{
    override func bind() {
        let input = SignUpViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty.asObservable(),
            passwordText: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
            passwordConfirmText: mainView.passwordConfirmTextField.rx.text.orEmpty.asObservable(),
            nicknameText: mainView.nickTextField.rx.text.orEmpty.asObservable(),
            emailValidOnClick: mainView.emailValidationButton.rx.tap.asObservable(),
            signUpOnClick: mainView.confirmButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // email 유효처리
        output.emailGuide
            .drive(mainView.emailGuide.rx.text)
            .disposed(by: disposeBag)
        output.emailValidation
            .drive(with: self) { owner, bool in
                let color = bool ? ColorStyle.confirm : ColorStyle.reject
                owner.mainView.emailGuide.textColor = color
            }
            .disposed(by: disposeBag)
        // 비밀번호 유효처리
        output.passwordGuide
            .drive(mainView.passwordGuide.rx.text)
            .disposed(by: disposeBag)
        output.passwordValidation
            .drive(with: self) { owner, bool in
                let color = bool ? ColorStyle.confirm : ColorStyle.reject
                owner.mainView.passwordGuide.textColor = color
            }
            .disposed(by: disposeBag)
        // 비밀번호 확인 유효처리
        output.passwordConfirmGuide
            .drive(mainView.passwordConfirmGuide.rx.text)
            .disposed(by: disposeBag)
        output.passwordConfirmValidation
            .drive(with: self) { owner, bool in
                let color = bool ? ColorStyle.confirm : ColorStyle.reject
                owner.mainView.passwordConfirmGuide.textColor = color
            }
            .disposed(by: disposeBag)
        // 닉네임 유효처리
        output.nicknameGuide
            .drive(mainView.nickGuide.rx.text)
            .disposed(by: disposeBag)
        output.nicknameValidation
            .drive(with: self) { owner, bool in
                let color = bool ? ColorStyle.confirm : ColorStyle.reject
                owner.mainView.nickGuide.textColor = color
            }
            .disposed(by: disposeBag)
        
        output.signUpValidation
            .drive(with: self) { owner, bool in
                let color = bool ? ColorStyle.darkYellow : ColorStyle.gray
                owner.mainView.confirmButton.configuration = .confirmButton(
                    message: "회원가입", color: color
                )
                owner.mainView.confirmButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
        output.signUpSuccessTrigger
            .drive(with: self) { owner, _ in
                owner.showToast("회원가입이 완료됐습니다!")
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
