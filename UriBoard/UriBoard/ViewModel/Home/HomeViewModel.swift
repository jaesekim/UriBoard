//
//  HomeViewModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType {

    var disposeBag = DisposeBag()

    struct Input {
        let readPostsQueryString: Observable<ReadPostsQueryString>
    }
    
    struct Output {
        let result: PublishSubject<Result<ReadPostsModel, APIError>>
    }
    
    func transform(input: Input) -> Output {
        let result = PublishSubject<Result<ReadPostsModel, APIError>>()
        
        input.readPostsQueryString
            .debug()
            .flatMap {
                return NetworkManager.shared.requestAPIResult(
                    type: ReadPostsModel.self,
                    router: Router.post(
                        router: .readPosts(query: $0)
                    )
                )
            }
            .bind(to: result)
            .disposed(by: disposeBag)

        return Output(
            result: result
        )
    }
}
