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

    let postUpdateTrigger = PublishRelay<String>()
    let postDeleteTrigger = PublishRelay<String>()
    
    struct Input {
        let postId: String
        let likeOnClick: Observable<Void>
        let commentOnClick: Observable<Void>
        let reboardOnClick: Observable<Void>
        let rightNavOnClick: Observable<()>?
    }
    struct Output {
        let result: PublishSubject<Result<ReadDetailPostModel, APIError>>
        let likeList: Driver<[String]>
        let reboardList: Driver<[String]>
        let commentList: Observable<[CommentModel]>
        let bottomSheetTrigger: Driver<Void>
        let navButtonTrigger: Driver<Void>
        let errorMessage: Driver<String>
        let deletePostResult: Driver<String>
    }
    func transform(input: Input) -> Output {
        
        let likeStatus = BehaviorRelay(value: false)
        let reboardStatus = BehaviorRelay(value: false)
        
        let outputResult = PublishSubject<Result<ReadDetailPostModel, APIError>>()
        let bottomSheetTrigger = PublishRelay<Void>()
        let navButtonTrigger = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        
        let likeRelayList = BehaviorRelay<[String]>(value: [])
        let reboardRelayList = BehaviorRelay<[String]>(value: [])
        let commentRelayList = BehaviorSubject<[CommentModel]>(value: [])
        
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
                    commentRelayList.onNext(success.comments)
                    reboardRelayList.accept(success.likes2)
                case .failure(_):
                    errorMessage.accept("로드에 실패했습니다")
                }
            }
            .disposed(by: disposeBag)
        
        input.rightNavOnClick?
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                navButtonTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        input.likeOnClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(likeContains)
            .flatMap {
                print("detail like onclick")
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
            .withLatestFrom(reboardContains)
            .flatMap {
                print("detail reboard onclick")
                return NetworkManager.shared.requestAPIResult(
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

        // 댓글 등록 버튼 클릭
        input.commentOnClick
            .bind(with: self) { owner, _ in
                bottomSheetTrigger.accept(())
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
                    errorMessage.accept("잠시 후 다시 시도해 주세요")
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
        
        // 게시물 삭제
        let deletePostResult = PublishRelay<String>()
        postDeleteTrigger
            .flatMap {
                NetworkManager.shared.requestDelete(
                    router: PostRouter.deletePost(id: $0)
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    deletePostResult.accept("삭제가 완료됐습니다")
                case .failure(_):
                    deletePostResult.accept("오류가 발생했습니다")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            result: outputResult,
            likeList: likeRelayList.asDriver(onErrorJustReturn: []),
            reboardList: reboardRelayList.asDriver(onErrorJustReturn: []), 
            commentList: commentRelayList.asObservable(),
            bottomSheetTrigger: bottomSheetTrigger.asDriver(onErrorJustReturn: ()),
            navButtonTrigger: navButtonTrigger.asDriver(onErrorJustReturn: ()),
            errorMessage: errorMessage.asDriver(onErrorJustReturn: ""), 
            deletePostResult: deletePostResult.asDriver(onErrorJustReturn: "")
        )
    }
}
