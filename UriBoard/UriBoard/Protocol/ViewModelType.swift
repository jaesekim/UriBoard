//
//  ViewModelType.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import Foundation
import RxSwift

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
