//
//  SignInView.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import UIKit
import SnapKit

final class SignInView: BaseView {

    let emailLabel = {
        let view = UILabel()
        view.text = "이메일"
        view.font = FontStyle.getFont(
            scale: .bold, size: .large
        )
        view.textColor = ColorStyle.black
        return view
    }()
    let emailTextField = {
        let view = UITextField.addLeftPadding(
            placeholder: "이메일을 입력해 주세요"
        )
        view.font = FontStyle.getFont(
            scale: .regular, size: .medium
        )
        return view
    }()
    let passwordLabel = {
        let view = UILabel()
        view.text = "비밀번호"
        view.font = FontStyle.getFont(
            scale: .bold, size: .large
        )
        view.textColor = ColorStyle.black
        return view
    }()
    let passwordTextField = {
        let view = UITextField.addLeftPadding(
            placeholder: "비밀번호를 입력해 주세요"
        )
        view.font = FontStyle.getFont(
            scale: .regular, size: .medium
        )
        return view
    }()
    let signInGuide = {
        let view = UILabel()
        view.font = FontStyle.getFont(
            scale: .regular,
            size: .small
        )
        view.textColor = ColorStyle.reject
        view.textAlignment = .center
        return view
    }()
    let confirmButton = {
        let view = UIButton()
        view.configuration = .confirmButton(
            message: "로그인",
            color: ColorStyle.gray
        )
        return view
    }()
    let singUpButton = TextButton(
        text: "회원이 아니십니까?",
        color: ColorStyle.moreLightDark
    )
}

extension SignInView {

    override func configureHierarchy() {
        [
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            signInGuide,
            confirmButton,
            singUpButton
        ].forEach { addSubview($0) }
    }

    override func configureConstraints() {

        emailLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(emailTextField.snp.top).offset(-20)
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(passwordLabel.snp.top).offset(-32)
        }
        passwordLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(passwordTextField.snp.top).offset(-20)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(snp.centerY).offset(-20)
        }
        signInGuide.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalTo(singUpButton.snp.top).offset(-20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        singUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
}
