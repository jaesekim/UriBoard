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
    
    struct Input {
        let rightNavButtonOnclick: Observable<()>?
        let leftNavButtonOnClick: Observable<()>?
        let boardContent: Observable<String>
    }
    
    struct Output {
        
    }
}

extension PostViewModel {
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
