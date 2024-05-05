//
//  CommentTableCellViewModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class CommentTableCellViewModel: ViewModelType {
    
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let handlerOnClick: Observable<Void>
        let postId: String
        let commentId: String
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
