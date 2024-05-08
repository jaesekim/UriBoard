//
//  PaymentsViewController.swift
//  UriBoard
//
//  Created by 김재석 on 5/7/24.
//

import UIKit
import iamport_ios
import WebKit
import RxSwift
import RxCocoa

final class PaymentsViewController: BaseViewController {

    let mainView = PaymentsView()
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        paymentBind()
    }
}

extension PaymentsViewController {
    private func paymentBind() {
        //mainView.payButton.rx
    }
}
