//
//  UserDefaultsManager.swift
//  UriBoard
//
//  Created by 김재석 on 4/23/24.
//

import Foundation

enum UserDefaultsManager {
    
    enum Key: String {
        case userEmail, nickname, userId, profileImage, accessToken, refreshToken
    }
    
    @UserDefaultsWrapper(
        key: Key.userEmail.rawValue,
        defaultValue: ""
    )
    static var userEmail
    
    @UserDefaultsWrapper(
        key: Key.nickname.rawValue,
        defaultValue: ""
    )
    static var nickname
    
    @UserDefaultsWrapper(
        key: Key.userId.rawValue,
        defaultValue: ""
    )
    static var userId
    
    @UserDefaultsWrapper(
        key: Key.profileImage.rawValue,
        defaultValue: ""
    )
    static var profileImage
    
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
