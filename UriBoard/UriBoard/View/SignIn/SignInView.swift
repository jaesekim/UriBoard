//
//  SignInView.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import UIKit
import SnapKit

final class SignInView: BaseView {

    let emailTextField = {
        let view = UITextField()
        return view
    }()
    let emailGuide = {
        let view = UILabel()
        view.font = FontStyle.getFont(
            scale: .regular, size: .small
        )
        return view
    }()
    let passwordTextField = {
        let view = UITextField()
        return view
    }()
    let passwordGuide = {
        let view = UILabel()
        view.font = FontStyle.getFont(
            scale: .regular, size: .small
        )
        return view
    }()
    let confirmButton = {
        let view = UIButton()
        view.configuration = .confirmButton(
            message: "로그인",
            color: <#T##UIColor?#>
        )
        return view
    }()
}

extension SignInView {

    override func configureHierarchy() {
        [
        ].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        <#code#>
    }
}
