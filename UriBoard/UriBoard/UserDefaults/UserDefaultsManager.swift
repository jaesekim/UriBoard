//
//  UserDefaultsManager.swift
//  UriBoard
//
//  Created by 김재석 on 4/23/24.
//

import Foundation

enum UserDefaultsManager {
    
    enum Key: String {
        case accessToken, refreshToken
    }
    
    @UserDefaultsWrapper(
        key: Key.accessToken.rawValue,
        defaultValue: ""
    )
    static var accessToken
    
    @UserDefaultsWrapper(
        key: Key.refreshToken.rawValue,
        defaultValue: ""
    )
    static var refreshToken
}
