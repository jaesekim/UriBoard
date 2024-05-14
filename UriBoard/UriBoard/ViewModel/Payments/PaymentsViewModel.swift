//
//  PaymentsViewModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/13/24.
//

import Foundation
import RxSwift
import RxCocoa

class PaymentsViewModel: ViewModelType {
    
    typealias paymentResult = Result<PaymentsValidationModel, APIError>

    var disposeBag = DisposeBag()
    let paymentsQuery = PublishSubject<PaymentsValidationQuery>()

    struct Input {
    }
    struct Output {
        let result: PublishSubject<paymentResult>
    }
    func transform(input: Input) -> Output {
        
        let outputResult = PublishSubject<paymentResult>()
    
        paymentsQuery
            .flatMap {
                print("!!@@##$$")
                dump($0)
                return NetworkManager.shared.requestAPIResult(
                    type: PaymentsValidationModel.self,
                    router: PaymentsRouter.validation(query: $0)
                )
            }
            .bind(to: outputResult)
            .disposed(by: disposeBag)

        return Output(result: outputResult)
    }
}
