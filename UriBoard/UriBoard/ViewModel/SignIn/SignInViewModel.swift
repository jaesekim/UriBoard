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
        let signUpOnClick: Observable<Void>
    }

    struct Output {
        let signInValidation: Driver<Bool>
        let signInGuide: Driver<String>
        let signInButtonOnClick: Driver<Void>
        let signUpbuttonOnClick: Driver<Void>
    }

    
}
// MARK: transform
extension SignInViewModel {
    func transform(input: Input) -> Output {
        
        let signInValid = BehaviorRelay(value: false)
        let signInGuide = PublishRelay<String>()
        let signInButtonTrigger = PublishRelay<Void>()
        let signUpButtonTrigger = PublishRelay<Void>()
        
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
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signInObservable)
//            .distinctUntilChanged { past, cur in
//                past.email != cur.email || past.password != cur.password
//            }
            .debug()
            .flatMap {
                NetworkManager.shared.requestAPIResult(
                    type: SignInModel.self,
                    router: Router.auth(router: .signIn(query: $0))
                )
            }
            .debug()
            .subscribe(with: self) { owner, value in
                switch value {
                case .success(let success):
                    print(success)
                    UserDefaultsManager.userEmail = success.email
                    UserDefaultsManager.nickname = success.nick
                    UserDefaultsManager.userId = success.user_id
                    UserDefaultsManager.profileImage = success.profileImage ?? ""
                    UserDefaultsManager.accessToken = success.accessToken
                    UserDefaultsManager.refreshToken = success.refreshToken
                    signInButtonTrigger.accept(())
                case .failure(let failure):
                    print(failure)
                    switch failure {
                    case .keyError:
                        signInGuide.accept("KEY ERROR")
                    case .overCall:
                        signInGuide.accept("과호출입니다. 잠시 후 다시 시도해 주세요")
                    case .invalidURL:
                        signInGuide.accept("잘못된 경로 접근입니다. 잠시 후 다시 시도해 주세요")
                    case .serverError:
                        signInGuide.accept("에러: 잠시 후 다시 시도해 주세요")
                    case .invalidRequest:
                        signInGuide.accept("이메일 및 비밀번호를 입력해 주세요")
                    case .invalidAccess:
                        print("가입되지 않은 계정이거나 비밀번호가 일치하지 않습니다")
                        signInGuide.accept("가입되지 않은 계정이거나 비밀번호가 일치하지 않습니다")
                    default:
                        signInGuide.accept("에러: 잠시 후 다시 시도해 주세요")
                    }
                }
            } onError: { _, _ in
                print("onerror")
            } onDisposed: { _ in
                print("ondisposed")
            }
            .disposed(by: disposeBag)
        //  연습 끝
    
        input.signUpOnClick
        // 버튼 과호출 방지
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                signUpButtonTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            signInValidation: signInValid.asDriver(),
            signInGuide: signInGuide.asDriver(onErrorJustReturn: ""),
            signInButtonOnClick: signInButtonTrigger.asDriver(onErrorJustReturn: ()),
            signUpbuttonOnClick: signUpButtonTrigger.asDriver(onErrorJustReturn: ())
        )
    }
}
