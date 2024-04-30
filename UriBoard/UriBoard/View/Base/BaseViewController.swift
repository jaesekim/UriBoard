//
//  BaseViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import UIKit
import RxSwift
import Toast

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        configureHierarchy()
        configureConstraints()
        configureView()
        bind()
    }
    
    func showToast(_ message: String) {
        view.makeToast(message)
    }
}

extension BaseViewController: NavigationSettings {
    
    @objc func setNavigationBar() {
        // push해서 들어간 ViewController NavigationItem 설정
        let backBarButtonItem = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: self,
            action: nil
        )
        backBarButtonItem.tintColor = ColorStyle.darkPurple
        navigationItem.backBarButtonItem = backBarButtonItem
    }
}

extension BaseViewController: UISettings {
    
    @objc func configureHierarchy() {}
    @objc func configureConstraints() {}
    @objc func configureView() {}
}

extension BaseViewController: RxBindSettings {
    
    @objc func bind() {}
}
