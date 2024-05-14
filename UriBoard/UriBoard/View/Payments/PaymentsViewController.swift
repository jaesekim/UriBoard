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
import Alamofire

final class PaymentsViewController: BaseViewController {

    let mainView = PaymentsView()
    override func loadView() {
        self.view = mainView
    }
    
    private let viewModel = PaymentsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPayments()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
}

extension PaymentsViewController {
    override func setNavigationBar() {
        setLeftNavigationItem()
        navigationItem.title = "후원하기"
    }
    private func setLeftNavigationItem() {
        let leftItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: nil
        )
        leftItem.tintColor = ColorStyle.lightDark
        navigationItem.leftBarButtonItem = leftItem
    }
}

extension PaymentsViewController {
    override func bind() {
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension PaymentsViewController {
    private func composePaymentsData() -> IamportPayment {
        return IamportPayment(
            pg: PG.html5_inicis.makePgRawName(
                pgId: "INIpayTest"
            ),
            merchant_uid: "ios_\(APIKey.key)_\(Int(Date().timeIntervalSince1970))",
            amount: "100"
        ).then {
            $0.pay_method = PayMethod.card.rawValue
            $0.name = "우리보드 후원하기"
            $0.buyer_name = APIKey.buyerName
            $0.app_scheme = APIKey.appScheme
        }
    }
    private func requestPayments() {
        Iamport.shared.paymentWebView(
            webViewMode: mainView.wkWebView,
            userCode: APIKey.payUserCode,
            payment: composePaymentsData()
        ) { [weak self] iamportResponse in
            // 결제 종료 후 실행되는 콜백 함수
            guard let self = self else  { return }
            if let success = iamportResponse?.success {
                guard let imp_uid = iamportResponse?.imp_uid else { return }
                do {
                    let urlRequest = try PaymentsRouter.validation(
                        query: PaymentsValidationQuery(
                            imp_uid: imp_uid,
                            post_id: APIKey.fundingId,
                            productName: "우리보드 후원",
                            price: 100
                        )
                    ).asURLRequest()

                    AF
                        .request(
                            urlRequest,
                            interceptor: InterceptorManager()
                        )
                        .validate(statusCode: 200..<300)
                        .responseDecodable(
                            of: PaymentsValidationModel.self
                        ) { response in
                            switch response.result {
                            case .success(let success):
                                self.dismiss(animated: true)
                            case .failure(let failure):
                                print(failure)
                            }
                        }
                } catch {
                    print(error)
                }
            }
        }
    }
}

extension PaymentsViewController {
    private func successAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "후원 감사합니다! 앞으로 더욱 발전하는 우리보드가 되겠습니다",
            preferredStyle: .alert
        )
        let ok = UIAlertAction(
            title: "확인",
            style: .default) { [weak self] _ in
                self?.dismiss(animated: true)
            }
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}
