//
//  PaymentsView.swift
//  UriBoard
//
//  Created by 김재석 on 5/7/24.
//

import UIKit
import SnapKit
import WebKit

final class PaymentsView: BaseView {

    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()
}

extension PaymentsView {
    override func configureHierarchy() {
        [
            wkWebView,
        ].forEach { addSubview($0) }
    }
    override func configureConstraints() {
        wkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    override func configureView() {
        super.configureView()
    }
}
