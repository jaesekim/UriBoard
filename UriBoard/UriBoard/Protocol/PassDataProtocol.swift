//
//  PassDataProtocol.swift
//  UriBoard
//
//  Created by 김재석 on 5/4/24.
//

import Foundation

protocol PassDataProtocol: AnyObject {
    func passData<T>(_ data: T)
}
