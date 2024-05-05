//
//  CommentSheetViewModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/4/24.
//

import Foundation
import RxSwift
import RxCocoa

class CommentSheetViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    let screenUpdateTrigger = PublishRelay<Void>()
    
    struct Input {
        let commentText: Observable<String>
        let sendButtonOnClick: Observable<Void>
        let postId: String
    }
    struct Output {
        let result: PublishSubject<Result<ReadDetailPostModel, APIError>>
        let sendButtonStatus: Driver<Bool>
        let commentList: Observable<[CommentModel]>
        let doneTirgger: Driver<Void>
        let errorMessage: Driver<String>
    }
    func transform(input: Input) -> Output {
        let outputResult = PublishSubject<Result<ReadDetailPostModel, APIError>>()
        let sendButtonStatus = BehaviorRelay(value: false)
        let commentRelayList = PublishSubject<[CommentModel]>()
        let doneTrigger = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()

        screenUpdateTrigger
            .flatMap {
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
                    commentRelayList.onNext(success.comments)
                case .failure(_):
                    errorMessage.accept("잠시 후 다시 시도해 주세요")
                }
            }
            .disposed(by: disposeBag)

        // 댓글 비어있을 때 버튼 비활성화
        input.commentText
            .map {
                $0.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
            }
            .map { $0.count > 0 }
            .bind(to: sendButtonStatus)
            .disposed(by: disposeBag)

        // 댓글 업로드
        input.sendButtonOnClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.commentText)
            .flatMap {
                NetworkManager.shared.requestAPIResult(
                    type: CommentModel.self,
                    router: CommentRouter.postComment(
                        query: CommentQuery(content: $0),
                        postId: input.postId
                    )
                )
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(_):
                    owner.screenUpdateTrigger.accept(())
                    doneTrigger.accept(())
                case .failure(_):
                    errorMessage.accept("업로드 실패")
                }
            }
            .disposed(by: disposeBag)

        return Output(
            result: outputResult,
            sendButtonStatus: sendButtonStatus.asDriver(),
            commentList: commentRelayList.asObservable(),
            doneTirgger: doneTrigger.asDriver(onErrorJustReturn: ()),
            errorMessage: errorMessage.asDriver(onErrorJustReturn: "")
        )
    }
}
