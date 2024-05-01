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
        // 사진 추가 output
        let addPhotoButtonOnClick: Driver<Void>
        // 선택된 사진 보여주는 용도
        let photoDataList: Observable<[Data]>
        // 에러메시지
        let errorMessage: Driver<String>
    }
}

extension PostViewModel {
    
    func transform(input: Input) -> Output {
        let cancelButtonTrigger = PublishRelay<Void>()
        let postingTrigger = PublishRelay<Void>()
        let postingValid = BehaviorRelay(value: false)
        let addPhotoButtonTrigger = PublishRelay<Void>()
        let errorMessage = BehaviorRelay<String>(value: "")
        
        // 게시물 등록 취소
        input.leftNavButtonOnClick?
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                cancelButtonTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        // 게시물 등록 버튼 활성화 유무
        input.boardContent
            .map {
                $0.trimmingCharacters(
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
        
        // 게시물 등록 버튼 누르기
        input.rightNavButtonOnclick?
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { [weak self] _ in
                NetworkManager.shared.uploadFiles(
                    type: ImageFilesModel.self,
                    router: Router.post(router: .imageUpload),
                    imgData: try self?.photoData.value() ?? []
                )
            }
            .subscribe(with: self) { owner, value in
                switch value {
                case .success(let success):
                    postContent(files: success.files)
                case .failure(let failure):
                    print(failure)
                    errorMessage.accept("이미지 업로드 실패")
                }
            }
            .disposed(by: disposeBag)
        
        // 이미지 추가 버튼 눌렀을 때
        input.addPhotoButtonOnClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                addPhotoButtonTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        // 등록버튼 눌렀을 때 이미지 업로드 이후 전체적인 게시글 업로드 로직 함수
        func postContent(files: [String]) {
            
            let postingObservable = input.boardContent
                .map {
                    CreatePostQuery(
                        content: $0,
                        files: files)
                }

            postingObservable
                .flatMap {
                    NetworkManager.shared.requestAPIResult(
                        type: CreatePostModel.self,
                        router: Router.post(router: .createPost(query: $0)))
                }
                .subscribe(with: self) { owner, value in
                    switch value {
                    case .success(let success):
                        postingTrigger.accept(())
                    case .failure(_):
                        errorMessage.accept("업로드를 실패했습니다")
                    }
                }
                .disposed(by: disposeBag)
        }
        
        return Output(
            rightNavButtonValid: postingValid.asDriver(),
            cancelOnClick: cancelButtonTrigger.asDriver(onErrorJustReturn: ()),
            postingOnClick: postingTrigger.asDriver(onErrorJustReturn: ()),
            addPhotoButtonOnClick: addPhotoButtonTrigger.asDriver(onErrorJustReturn: ()),
            photoDataList: photoData.asObserver(),
            errorMessage: errorMessage.asDriver()
        )
    }
}
