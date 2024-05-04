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
    
    struct Input {
        let likeOnClick: Observable<Void>
        let reboardOnClick: Observable<Void>
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
        let commentRelayList = PublishRelay<[String]>()
        let reboardRelayList = PublishRelay<[String]>()
        
        let errorMessage = PublishRelay<String>()
        
        let likeContains = likeRelayList
            .map {
                $0.contains(UserDefaultsManager.userId)
            }
        
        let reboardContains = reboardRelayList
            .map {
                $0.contains(UserDefaultsManager.userId)
            }
        
        input.likeOnClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(likeContains)
            .flatMap {
                NetworkManager.shared.requestAPIResult(
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
            .withLatestFrom(reboardContains)
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
