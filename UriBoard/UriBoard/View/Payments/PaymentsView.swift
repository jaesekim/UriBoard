//
//  PaymentsView.swift
//  UriBoard
//
//  Created by 김재석 on 5/7/24.
//

import UIKit
import SnapKit

final class PaymentsView: BaseView {
    
    let mainLabel = {
        let view = UILabel()
        view.text = "후원하기"
        view.font = .systemFont(ofSize: 40)
        view.textAlignment = .center
        return view
    }()
    let contentLabel = {
        let view = UILabel()
        view.text = "우리보드 앱의 더 좋은 서비스 개발을 위해 후원자가 되어주세요!"
        view.font = .systemFont(ofSize: 24)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    let priceLabel = {
        let view = UILabel()
        view.text = "후원금액: 1,000원"
        view.font = .systemFont(ofSize: 24)
        return view
    }()
    let payButton = {
        let view = UIButton()
        view.setTitle(
            "후원하기",
            for: .normal
        )
        view.backgroundColor = ColorStyle.confirm
        return view
    }()
}

extension PaymentsView {
    override func configureHierarchy() {
        [
            mainLabel,
            contentLabel,
            priceLabel,
            payButton,
        ].forEach { addSubview($0) }
    }
    override func configureConstraints() {
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(120)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        payButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-60)
        }
    }
    override func configureView() {
        super.configureView()
    }
}
