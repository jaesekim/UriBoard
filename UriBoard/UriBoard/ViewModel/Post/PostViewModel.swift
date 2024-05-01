//
//  PostViewModel.swift
//  UriBoard
//
//  Created by 김재석 on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

class PostViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    let photoData = BehaviorSubject<[Data]>(value: [])

    struct Input {
        let rightNavButtonOnclick: Observable<()>?
        let leftNavButtonOnClick: Observable<()>?
        let addPhotoButtonOnClick: Observable<Void>
        let boardContent: Observable<String>
    }
    
    struct Output {
        let rightNavButtonValid: Driver<Bool>
        let cancelOnClick: Driver<Void>
        let postingOnClick: Driver<Void>
        let isPostSuccess: Driver<Bool>
        // 사진 추가 output
        let addPhotoButtonOnClick: Driver<Void>
        let photoDataList: Observable<[Data]>
    }
}

extension PostViewModel {
    
    func transform(input: Input) -> Output {
        let cancelButtonTrigger = PublishRelay<Void>()
        let postingTrigger = PublishRelay<Void>()
        let postingValid = BehaviorRelay(value: false)
        let postSuccess = BehaviorRelay(value: false)
        let addPhotoButtonTrigger = PublishRelay<Void>()
        
        
        let postingObservable = input.boardContent
            .map {
                CreatePostQuery(
                    content: $0,
                    files: [])
            }

        postingObservable
            .map {
                $0.content.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
            }
            .bind(with: self) { owner, content in
                if content.isEmpty {
                    postingValid.accept(false)
                } else {
                    postingValid.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        input.leftNavButtonOnClick?
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                cancelButtonTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        input.rightNavButtonOnclick?
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(postingObservable)
            .flatMap {
                NetworkManager.shared.requestAPIResult(
                    type: CreatePostModel.self,
                    router: Router.post(router: .createPost(query: $0)))
            }
            .subscribe(with: self) { owner, value in
                switch value {
                case .success(_):
                    print("true")
                    postSuccess.accept(true)
                    postingTrigger.accept(())
                case .failure(_):
                    print("fail")
                    postSuccess.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.addPhotoButtonOnClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                addPhotoButtonTrigger.accept(())
            }
            .disposed(by: disposeBag)

        return Output(
            rightNavButtonValid: postingValid.asDriver(),
            cancelOnClick: cancelButtonTrigger.asDriver(onErrorJustReturn: ()),
            postingOnClick: postingTrigger.asDriver(onErrorJustReturn: ()),
            isPostSuccess: postSuccess.asDriver(),
            addPhotoButtonOnClick: addPhotoButtonTrigger.asDriver(onErrorJustReturn: ()),
            photoDataList: photoData.asObservable()
        )
    }
}
