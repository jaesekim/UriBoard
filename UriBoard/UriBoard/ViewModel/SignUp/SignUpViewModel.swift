//
//  SignUpViewModel.swift
//  UriBoard
//
//  Created by 김재석 on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
   

    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let passwordConfirmText: Observable<String>
        let nicknameText: Observable<String>
        
        let emailValidOnClick: Observable<Void>
        let signUpOnClick: Observable<Void>
    }
    
    struct Output {
        let signUpValidation: Driver<Bool>
        let signUpSuccessTrigger: Driver<Void>
        let signUpFailTrigger: Driver<APIError>
        
        let emailGuide: Driver<String>
        let passwordGuide: Driver<String>
        let passwordConfirmGuide: Driver<String>
        let nicknameGuide: Driver<String>
        
        let emailValidation: Driver<Bool>
        let passwordValidation: Driver<Bool>
        let passwordConfirmValidation: Driver<Bool>
        let nicknameValidation: Driver<Bool>
    }
    
    
}
// MARK: transform
extension SignUpViewModel {
    func transform(input: Input) -> Output {

        var emailValidCheck = false
        
        let signUpValid = BehaviorRelay(value: false)
        let signUpTirgger = PublishRelay<Void>()
        let signUpFailure = PublishRelay<APIError>()

        // 유효한 값에 따라서 가이드 메시지 변경
        let emailGuide = BehaviorRelay(
            value: "사용할 이메일을 입력 후 중복확인을 눌러주세요"
        )
        let passwordGuide = BehaviorRelay(
            value: "8자 이상의 비밀번호를 입력해 주세요"
        )
        let passwordConfirmGuide = BehaviorRelay(
            value: "동일한 비밀번호를 입력해 주세요"
        )
        let nicknameGuide = BehaviorRelay(
            value: "사용할 닉네임을 입력해 주세요"
        )
        // 유효한 값에 따라서 빨간색/초록색으로 변경해서 보여줄 상태 Bool값
        let emailValid = PublishRelay<Bool>()
        let passwordValid = PublishRelay<Bool>()
        let passwordConfirmValid = PublishRelay<Bool>()
        let nicknameValid = PublishRelay<Bool>()
        
        let emailObservable = input.emailText
            .map {
                EmailValidationQuery(email: $0)
            }
        
        input.emailValidOnClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(emailObservable)
            .flatMap {
                NetworkManager.shared.requestAPIResult(
                    type: EmailValidationModel.self,
                    router: Router.auth(
                        router: .emailValidation(query: $0)
                    )
                )
            }
            .subscribe(with: self) { owner, value in
                switch value {
                case .success(let success):
                    emailValidCheck = true
                case .failure(let failure):
                    emailValidCheck = false
                }
            } onError: { object, error in
                emailValidCheck = false
            }
            .disposed(by: disposeBag)


        // 이메일 유효성 검사
        let emailStatus = input.emailText
            .map { value in
               return value.contains("@") && emailValidCheck
            }
        // 비밀번호 유효성 검사
        let passStatus = input.passwordText
            .map {
                $0.count >= 8
            }
        // 비밀번호 확인 유효성 검사
        let passConfirmStatus = Observable
            .combineLatest(
                input.passwordText,
                input.passwordConfirmText
            )
            .map { pass1, pass2 in
                return pass1 == pass2
            }
        // 닉네임 유효성 검사
        let nickStatus = input.nicknameText
            .map {
                $0.count >= 2
            }
        // 이메일 유효성 검사 후 데이터 전달
        emailStatus
            .bind(with: self) { owner, bool in
                emailGuide.accept(
                    bool ? "사용가능한 이메일입니다!" :
                        "이메일 중복 검사를 다시 시도해 주세요"
                )
                emailValid.accept(bool)
            }
            .disposed(by: disposeBag)
        // 비밀번호 유효성 검사 후 데이터 전달
        passStatus
            .bind(with: self) { owner, bool in
                passwordGuide.accept(
                    bool ? "사용가능한 비밀번호입니다!" :
                        "8자 이상의 비밀번호를 입력해 주세요"
                )
                passwordValid.accept(bool)
            }
            .disposed(by: disposeBag)
        // 비밀번호 확인 유효성 검사 후 데이터 전달
        passConfirmStatus
            .bind(with: self) { owner, bool in
                passwordConfirmGuide.accept(
                    bool ? "비밀번호가 일치합니다!" :
                        "비밀번호가 일치하지 않습니다"
                )
                passwordConfirmValid.accept(bool)
            }
            .disposed(by: disposeBag)
        // 닉네임 유효성 검사 후 데이터 전달
        nickStatus
            .bind(with: self) { owner, bool in
                nicknameGuide.accept(
                    bool ? "사용 가능한 닉네임입니다!" :
                        "두 글자 이상의 닉네임을 입력해 주세요"
                )
                nicknameValid.accept(bool)
            }
            .disposed(by: disposeBag)

        // 입력 받은 값 combine으로 묶어주기
        let signUpCombine = Observable
            .combineLatest(
                emailStatus,
                passStatus,
                passConfirmStatus,
                nickStatus
            )

        // 회원가입 버튼 활성화 여부
        signUpCombine
            .bind(with: self) { owner, bool in
                if emailValidCheck && bool.0 && bool.1 && bool.2 && bool.3 {
                    signUpValid.accept(true)
                } else {
                    signUpValid.accept(false)
                }
            }
            .disposed(by: disposeBag)

        // 회원가입 쿼리 만들어 주기
        let signUpObservable = Observable
            .combineLatest(
                input.emailText,
                input.passwordText,
                input.nicknameText
            )
            .map { email, password, nick in
                SignUpQuery(
                    email: email,
                    password: password,
                    nick: nick
                )
            }
        // 애초에 유효한 회원가입이 아니면 버튼을 누를 수 없도록 설정
        input.signUpOnClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signUpObservable)
            .flatMap {
                NetworkManager.shared.requestAPIResult(
                    type: SignUpModel.self,
                    router: Router.auth(router: .signUp(query: $0))
                )
            }
            .subscribe(with: self) { owner, value in
                switch value {
                case .success(let success):
                    signUpTirgger.accept(())
                case .failure(let failure):
                    signUpFailure.accept(failure)
                }
            } onError: { object, error in
                signUpFailure.accept(.serverError)
            }
            .disposed(by: disposeBag)

        return Output(
            signUpValidation: signUpValid.asDriver(),
            signUpSuccessTrigger: signUpTirgger.asDriver(
                onErrorJustReturn: ()
            ), 
            signUpFailTrigger: signUpFailure.asDriver(
                onErrorJustReturn: .serverError
            ),
            emailGuide: emailGuide.asDriver(),
            passwordGuide: passwordGuide.asDriver(),
            passwordConfirmGuide: passwordConfirmGuide.asDriver(),
            nicknameGuide: nicknameGuide.asDriver(),
            emailValidation: emailValid.asDriver(
                onErrorJustReturn: false
            ),
            passwordValidation: passwordValid.asDriver(
                onErrorJustReturn: false
            ),
            passwordConfirmValidation: passwordConfirmValid.asDriver(
                onErrorJustReturn: false
            ),
            nicknameValidation: nicknameValid.asDriver(
                onErrorJustReturn: false
            )
        )
    }
}
