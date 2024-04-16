//
//  SignInViewModel.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewModel: ViewModelType {

    var disposeBag = DisposeBag()

    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let signInOnClick: Observable<Void>
    }

    struct Output {
        let signInValidation: Driver<Bool>
        let signInButtonOnClick: Driver<Void>
    }

    func transform(input: Input) -> Output {
        
        let signInValid = BehaviorRelay(value: false)
        let signInButtonTrigger = PublishRelay<Void>()
        
        let signInObservable = Observable
            .combineLatest(
                input.emailText,
                input.passwordText
            )
            .map { email, password in
                return SignInQuery(
                    email: email,
                    password: password
                )
            }
            
        signInObservable
            .bind(with: self) { owner, signIn in
                if signIn.email.contains("@") && signIn.password.count >= 8 {
                    signInValid.accept(true)
                } else {
                    signInValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.signInOnClick
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signInObservable)
            .distinctUntilChanged { past, cur in
                past.email != cur.email || past.password != cur.password
            }
            .flatMap {
                AuthNetworkManager.shared.requestAPI(
                    type: SignInModel.self,
                    router: Router.auth(router: .signIn(query: $0))
                )
            }.debug()
            .subscribe(with: self) { owner, _ in
                signInButtonTrigger.accept(())
            } onError: { a, b in
                print(a)
                print("=========")
                print(b)
            }
            .disposed(by: disposeBag)

        
        return Output(
            signInValidation: signInValid.asDriver(),
            signInButtonOnClick: signInButtonTrigger.asDriver(onErrorJustReturn: ())
        )
    }
}
