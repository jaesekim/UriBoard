//
//  UserDefaultsWrapper.swift
//  UriBoard
//
//  Created by 김재석 on 4/23/24.
//

import Foundation

@propertyWrapper
struct UserDefaultsWrapper<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(
                forKey: key
            ) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
