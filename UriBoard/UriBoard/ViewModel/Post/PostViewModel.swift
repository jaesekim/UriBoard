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
    let photoData = BehaviorRelay<[Data]>(value: [])
    
    struct Input {
        let rightNavButtonOnclick: Observable<()>?
        let leftNavButtonOnClick: Observable<()>?
        let addContentButtonOnClick: Observable<Void>
        let boardContent: Observable<String>
    }
    
    struct Output {
        let addContentButtonValid: Driver<Bool>
        let cancelOnClick: Driver<Void>
        let postingOnClick: Driver<Void>
        // 사진 추가 output
        let addPhotoButtonOnClick: Driver<Void>
        // 선택된 사진 보여주는 용도
        let photoDataList: Observable<[Data]>
        // 에러메시지
        let errorMessage: Driver<String>
        let result: PublishRelay<Result<CreatePostModel, APIError>>
    }
}

extension PostViewModel {

    func transform(input: Input) -> Output {
        let cancelButtonTrigger = PublishRelay<Void>()
        let postingTrigger = BehaviorRelay<Void>(value: ())
        let postingValid = BehaviorRelay(value: false)
        let addPhotoButtonTrigger = PublishRelay<Void>()
        let errorMessage = BehaviorRelay<String>(value: "")
        
        // 사진 데이터 넣는 배열
        let photoStringArr = PublishRelay<[String]>()
        
        let result = PublishRelay<Result<CreatePostModel, APIError>>()
        var contentText = ""
        
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
                    contentText = content
                }
            }
            .disposed(by: disposeBag)
        
        // 이미지 추가 버튼 눌렀을 때
        input.rightNavButtonOnclick?
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                addPhotoButtonTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        // 게시물 등록 클릭 + 사진을 선택하지 않았을 때 경우
        input.addContentButtonOnClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .filter { [weak self] _ in
                guard let data = self?.photoData.value else {
                    return false
                }
                return data.isEmpty
            }
            .map {
                CreatePostQuery(
                    content: contentText,
                    files: []
                )
            }
            .flatMap {
                NetworkManager.shared.requestAPIResult(
                    type: CreatePostModel.self,
                    router: Router.post(router: .createPost(query: $0))
                )
            }
            .bind(to: result)
            .disposed(by: disposeBag)

        // 게시물 등록 클릭 + 사진을 선택했을 때
        input.addContentButtonOnClick
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .filter { [weak self] _ in
                guard let data = self?.photoData.value else {
                    return false
                }
                return !data.isEmpty
            }
            .flatMap { [weak self] _ -> Single<Result<ImageFilesModel, APIError>> in
                
                guard let data = self?.photoData.value else {
                    return Single.just(.failure(.serverError))
                }
                return NetworkManager.shared.uploadFiles(
                    type: ImageFilesModel.self,
                    router: Router.post(router: .imageUpload),
                    imgData: data
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    photoStringArr.accept(success.files)
                case .failure(_):
                    errorMessage.accept("이미지 업로드 실패")
                }
            }
            .disposed(by: disposeBag)

        photoStringArr
            .map {
                CreatePostQuery(content: contentText, files: $0)
            }
            .flatMap {
                NetworkManager.shared.requestAPIResult(
                    type: CreatePostModel.self,
                    router: Router.post(router: .createPost(query: $0))
                )
            }
            .bind(to: result)
            .disposed(by: disposeBag)
            
            
        
        return Output(
            addContentButtonValid: postingValid.asDriver(),
            cancelOnClick: cancelButtonTrigger.asDriver(onErrorJustReturn: ()),
            postingOnClick: postingTrigger.asDriver(),
            addPhotoButtonOnClick: addPhotoButtonTrigger.asDriver(onErrorJustReturn: ()),
            photoDataList: photoData.asObservable(),
            errorMessage: errorMessage.asDriver(),
            result: result
        )
    }
}

