//
//  BoardTableViewModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class BoardTableViewModel {
    
    var disposeBag = DisposeBag()
    
    let a = [String]()

    struct Input {
        let likeOnClick: Observable<Void>
        let inputLikeList: [String]
        let reboardOnClick: Observable<Void>
        let inputReboardList: [String]
        let postId: String
    }
    
    struct Output {
        let likeList: Driver<[String]>
        let reboardList: Driver<[String]>
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let likeStatus = BehaviorRelay(value: false)
        let reboardStatus = BehaviorRelay(value: false)

        let likeRelayList = PublishRelay<[String]>()
        let reboardRelayList = PublishRelay<[String]>()
        let errorMessage = PublishRelay<String>()
        
        input.likeOnClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map {
                print($0)
                // 포함돼 있다면 true -> 다시 누른것이니까 좋아요 취소
                return input.inputLikeList.contains(UserDefaultsManager.userId)
            }
            .flatMap {
                return NetworkManager.shared.requestAPIResult(
                    type: PostLikeModel.self,
                    router: Router.like(
                        router: .postLike(
                            id: input.postId,
                            query: PostLikeQuery(
                                like_status: !$0
                            )
                        )
                    )
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    likeStatus.accept(success.like_status)
                case .failure(_):
                    errorMessage.accept("잠시 후 다시 시도해 주세요")
                }
            }
            .disposed(by: disposeBag)
        
        input.reboardOnClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map {
                input.inputReboardList.contains(UserDefaultsManager.userId)
            }
            .flatMap {
                NetworkManager.shared.requestAPIResult(
                    type: PostLikeModel.self,
                    router: Router.like(
                        router: .postReboard(
                            id: input.postId,
                            query: PostLikeQuery(
                                like_status: !$0
                            )
                        )
                    )
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    reboardStatus.accept(success.like_status)
                case .failure(_):
                    errorMessage.accept("잠시 후 다시 시도해 주세요")
                }
            }
            .disposed(by: disposeBag)
        
        likeStatus
            .flatMap { _ in
                NetworkManager.shared.requestAPIResult(
                    type: ReadDetailPostModel.self,
                    router: Router.post(
                        router: .readDetailPost(id: input.postId)
                    )
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    likeRelayList.accept(success.likes)
                case .failure(_):
                    errorMessage.accept("잠시후 다시 시도해 주세요")
                }
            }
            .disposed(by: disposeBag)
        
        reboardStatus
            .flatMap { _ in
                NetworkManager.shared.requestAPIResult(
                    type: ReadDetailPostModel.self,
                    router: Router.post(
                        router: .readDetailPost(id: input.postId)
                    )
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    reboardRelayList.accept(success.likes2)
                case .failure(_):
                    errorMessage.accept("잠시후 다시 시도해 주세요")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            likeList: likeRelayList.asDriver(onErrorJustReturn: []),
            reboardList: reboardRelayList.asDriver(onErrorJustReturn: []),
            errorMessage: errorMessage.asDriver(onErrorJustReturn: "")
        )
    }
}
