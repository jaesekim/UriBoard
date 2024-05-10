//
//  EditProfileViewModel.swift
//  UriBoard
//
//  Created by 김재석 on 5/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class EditProfileViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()

    struct Input {
        let nickTextField: Observable<String>
    }
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        let nickValidation = input.nickTextField
            .distinctUntilChanged()
            .map { $0.count >= 2 }
        
        
        return Output()
    }
}
