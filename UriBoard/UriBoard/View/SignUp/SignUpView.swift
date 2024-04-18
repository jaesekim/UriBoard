//
//  SignUpView.swift
//  UriBoard
//
//  Created by 김재석 on 4/15/24.
//

import UIKit
import SnapKit

final class SignUpView: BaseView {

    let emailTextField = {
        let view = UITextField.addLeftPadding(
            placeholder: "이메일"
        )
        view.font = FontStyle.getFont(
            scale: .regular, size: .small
        )
        return view
    }()
    let emailGuide = {
        let view = UILabel()
        view.text = "사용 가능한 이메일을 입력해 주세요"
        view.font = FontStyle.getFont(
            scale: .bold, size: .small
        )
        view.textColor = ColorStyle.black
        return view
    }()
    let emailValidationButton = {
        let view = UIButton()
        view.configuration = .confirmButton(
            message: "중복확인",
            color: ColorStyle.darkYellow
        )
        return view
    }()
    let passwordTextField = {
        let view = UITextField.addLeftPadding(
            placeholder: "비밀번호"
        )
        
        view.font = FontStyle.getFont(
            scale: .regular, size: .small
        )
        return view
    }()
    let passwordGuide = {
        let view = UILabel()
        view.text = "8자 이상의 비밀번호를 입력해 주세요"
        view.font = FontStyle.getFont(
            scale: .bold, size: .small
        )
        view.textColor = ColorStyle.black
        return view
    }()
    let passwordConfirmTextField = {
        let view = UITextField.addLeftPadding(
            placeholder: "비밀번호 재입력"
        )
        view.font = FontStyle.getFont(
            scale: .regular, size: .small
        )
        return view
    }()
    let passwordConfirmGuide = {
        let view = UILabel()
        view.text = "8자 이상의 비밀번호를 입력해 주세요"
        view.font = FontStyle.getFont(
            scale: .bold, size: .small
        )
        view.textColor = ColorStyle.black
        return view
    }()
    let nickTextField = {
        let view = UITextField.addLeftPadding(
            placeholder: "닉네임"
        )
        view.font = FontStyle.getFont(
            scale: .regular, size: .small
        )
        return view
    }()
    let nickGuide = {
        let view = UILabel()
        view.text = "사용할 닉네임을 입력해 주세요"
        view.font = FontStyle.getFont(
            scale: .bold, size: .small
        )
        view.textColor = ColorStyle.black
        return view
    }()
    let confirmButton = {
        let view = UIButton()
        view.configuration = .confirmButton(
            message: "회원가입",
            color: ColorStyle.gray
        )
        return view
    }()
}

extension SignUpView {
    override func configureHierarchy() {

        [
            emailTextField,
            emailGuide,
            emailValidationButton,
            passwordTextField,
            passwordGuide,
            passwordConfirmTextField,
            passwordConfirmGuide,
            nickTextField,
            nickGuide,
            confirmButton,
        ].forEach { addSubview($0) }
    }
    override func configureConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(emailValidationButton.snp.leading).offset(-12)
            make.height.equalTo(44)
        }
        emailValidationButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(80)
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.trailing.equalToSuperview().offset(-20)
        }
        emailGuide.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(22)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailGuide.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        passwordGuide.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(22)
        }
        passwordConfirmTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordGuide.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        passwordConfirmGuide.snp.makeConstraints { make in
            make.top.equalTo(passwordConfirmTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(22)
        }
        nickTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordConfirmGuide.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        nickGuide.snp.makeConstraints { make in
            make.top.equalTo(nickTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(22)
        }
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
}
