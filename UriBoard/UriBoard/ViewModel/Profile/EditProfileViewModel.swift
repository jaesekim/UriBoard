//
//  EditProfileViewModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class EditProfileViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    let existedImage = BehaviorRelay<Data>(value: Data())
    let profileImage = BehaviorRelay<Data>(value: Data())

    struct Input {
        let nickTextField: Observable<String>
        let confirmButtonOnClick: Observable<Void>
    }
    struct Output {
        let updateValidation: Driver<Bool>
        let validationGuide: Driver<String>
        let updateCompleteTrigger: Driver<Void>
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let imgUpdateValid = BehaviorRelay<Bool>(value: false)
        let nickUpdateValid = BehaviorRelay<Bool>(value: false)
        let updateValidation = BehaviorRelay<Bool>(value: false)
        let validationGuide = PublishRelay<String>()
        let updateCompleteTrigger = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        
        print(input.nickTextField)
        
        let queryObservable = Observable.combineLatest(
            profileImage,
            input.nickTextField
        )
        .map { profile, nickname in
            return ProfileQuery(
                nick: nickname,
                profile: profile
            )
        }
        
        Observable
            .combineLatest(
                existedImage,
                profileImage
            )
            .map {
                return $0 != $1
            }
            .bind(to: imgUpdateValid)
            .disposed(by: disposeBag)

        input.nickTextField
            .distinctUntilChanged()
            .filter { $0 != UserDefaultsManager.nickname}
            .map {
                $0.count >= 2 && $0.count <= 8
            }
            .bind(with: self) { owner, bool in
                bool ? validationGuide.accept("사용 가능한 닉네임입니다") : 
                validationGuide.accept("2 ~ 8 글자의 닉네임을 입력해 주세요")
                nickUpdateValid.accept(bool)
            }
            .disposed(by: disposeBag)
        
        // 이미지, 닉네임 둘 중 하나만 변경돼도 업데이트 OK
        Observable
            .combineLatest(
                imgUpdateValid,
                nickUpdateValid
            )
            .map { img, nick in
                img || nick
            }
            .bind(to: updateValidation)
            .disposed(by: disposeBag)

        input.nickTextField
            .distinctUntilChanged()
            .filter { $0 == UserDefaultsManager.nickname }
            .map { $0 == UserDefaultsManager.nickname }
            .bind(with: self) { owner, nick in
                nickUpdateValid.accept(false)
                validationGuide.accept("")
            }
            .disposed(by: disposeBag)

        input.confirmButtonOnClick
            .withLatestFrom(queryObservable)
            .flatMap {
                NetworkManager.shared.updateProfile(query: $0)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    UserDefaultsManager.nickname = success.nick
                    UserDefaultsManager.profileImage = success.profileImage ?? ""
                    updateCompleteTrigger.accept(())
                case .failure(let failure):
                    errorMessage.accept("잠시 후 다시 시도해 주세요")
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            updateValidation: updateValidation.asDriver(onErrorJustReturn: false),
            validationGuide: validationGuide.asDriver(onErrorJustReturn: ""),
            updateCompleteTrigger: updateCompleteTrigger.asDriver(onErrorJustReturn: ()),
            errorMessage: errorMessage.asDriver(onErrorJustReturn: "")
        )
    }
}
