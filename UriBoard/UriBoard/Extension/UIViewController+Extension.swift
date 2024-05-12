//
//  UIViewController+Extension.swift
//  UriBoard
//
//  Created by 김재석 on 4/19/24.
//

import UIKit

extension UIViewController {
    
    func rootViewTransition() {

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

        let sceneDelegate = windowScene.delegate as? SceneDelegate

        sceneDelegate?.window?.rootViewController = TabBarController()
        sceneDelegate?.window?.makeKey()
    }
    
    func signInViewTransition() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

        let sceneDelegate = windowScene.delegate as? SceneDelegate

        sceneDelegate?.window?.rootViewController = SignInViewController()
        sceneDelegate?.window?.makeKey()
    }
}
