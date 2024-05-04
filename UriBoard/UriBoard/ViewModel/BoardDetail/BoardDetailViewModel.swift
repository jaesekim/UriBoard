//
//  BoardDetailViewModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoardDetailViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()

    let viewWillAppearTrigger = PublishSubject<String>()

    struct Input {
        let postId: String
        let likeOnClick: Observable<Void>
        let commentOnClick: Observable<Void>
        let reboardOnClick: Observable<Void>
        
    }
    struct Output {
        let result: PublishSubject<Result<ReadDetailPostModel, APIError>>
        let likeList: Driver<[String]>
        let reboardList: Driver<[String]>
        let errorMessage: Driver<String>
    }
    func transform(input: Input) -> Output {
        
        let likeStatus = BehaviorRelay(value: false)
        let reboardStatus = BehaviorRelay(value: false)
        
        let outputResult = PublishSubject<Result<ReadDetailPostModel, APIError>>()
        let errorMessage = PublishRelay<String>()
        
        let likeRelayList = PublishRelay<[String]>()
        let commentRelayList = PublishRelay<[String]>()
        let reboardRelayList = PublishRelay<[String]>()
        
        let likeContains = likeRelayList
            .map {
                $0.contains(UserDefaultsManager.userId)
            }
        
        let reboardContains = reboardRelayList
            .map {
                $0.contains(UserDefaultsManager.userId)
            }
        
        viewWillAppearTrigger
            .flatMap {
                NetworkManager.shared.requestAPIResult(
                    type: ReadDetailPostModel.self,
                    router: Router.post(
                        router: .readDetailPost(id: $0)
                    )
                )
            }
            .subscribe(with: self) { owner, result in
                outputResult.onNext(result)
                switch result {
                case .success(let success):
                    likeRelayList.accept(success.likes)
                    commentRelayList.accept(success.comments)
                    reboardRelayList.accept(success.likes2)
                case .failure(_):
                    errorMessage.accept("로드에 실패했습니다")
                }
            }
            .disposed(by: disposeBag)
        
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
            result: outputResult,
            likeList: likeRelayList.asDriver(onErrorJustReturn: []),
            reboardList: reboardRelayList.asDriver(onErrorJustReturn: []),
            errorMessage: errorMessage.asDriver(onErrorJustReturn: "")
        )
    }
}
