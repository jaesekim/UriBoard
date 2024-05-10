//
//  ProfileViewModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/9/24.
//

import Foundation
import RxSwift
import RxCocoa
final
class ProfileViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    let viewWillAppearTrigger = PublishRelay<String>()
    
    struct Input {
        
    }
    struct Output {
        let result: PublishSubject<Result<ProfileModel, APIError>>
    }

    func transform(input: Input) -> Output {
        
        let outputResult = PublishSubject<Result<ProfileModel, APIError>>()

        viewWillAppearTrigger
            .flatMap { userId in
                if userId == UserDefaultsManager.userId {
                    NetworkManager.shared.requestAPIResult(
                        type: ProfileModel.self,
                        router: ProfileRouter.myProfile
                    )
                } else {
                    NetworkManager.shared.requestAPIResult(
                        type: ProfileModel.self,
                        router: ProfileRouter.otherProfile(
                            userId: userId
                        )
                    )
                }
            }
            .subscribe(with: self) { owner, result in
                outputResult.onNext(result)
            }
            .disposed(by: disposeBag)

        return Output(
            result: outputResult
        )
    }
}
