//
//  ProfileViewModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/9/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    let viewWillAppearTrigger = PublishRelay<String>()
    let followingButtonOnClick = PublishRelay<Bool>()

    struct Input {
        let profileEditButtonOnClick: Observable<Void>
        let userId: String
    }
    struct Output {
        let result: PublishSubject<Result<ProfileModel, APIError>>
        let profileEditButtonTrigger: Driver<Void>
        let followerList: Driver<[UserInfo]>
        let followingList: Driver<[UserInfo]>
        let errorMessage: Driver<String>
    }

    func transform(input: Input) -> Output {
        
        let outputResult = PublishSubject<Result<ProfileModel, APIError>>()
        
        let followingList = PublishRelay<[UserInfo]>()
        let followerList = PublishRelay<[UserInfo]>()

        let errorMessage = PublishRelay<String>()

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
                switch result {
                case .success(let success):
                    followerList.accept(success.followers)
                    followingList.accept(success.following)
                case .failure(_):
                    errorMessage.accept("잠시 후 다시 시도해 주세요")
                }
            }
            .disposed(by: disposeBag)
        
        followingButtonOnClick
            .flatMap { bool in
                if bool {
                    NetworkManager.shared.requestAPIResult(
                        type: FollowModel.self,
                        router: FollowRouter.postFollow(
                            id: input.userId
                        )
                    )
                } else {
                    NetworkManager.shared.requestAPIResult(
                        type: FollowModel.self,
                        router: FollowRouter.deleteFollow(
                            id: input.userId
                        )
                    )
                }
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.viewWillAppearTrigger.accept(input.userId)
                case .failure(let failure):
                    errorMessage.accept("Error: \(failure.rawValue) 잠시 후 다시 시도해 주세요")
                }
            }
            .disposed(by: disposeBag)

        return Output(
            result: outputResult,
            profileEditButtonTrigger: input.profileEditButtonOnClick.asDriver(onErrorJustReturn: ()),
            followerList: followerList.asDriver(onErrorJustReturn: []),
            followingList: followingList.asDriver(onErrorJustReturn: []),
            errorMessage: errorMessage.asDriver(onErrorJustReturn: "")
        )
    }
}
