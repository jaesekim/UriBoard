//
//  BaseViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        configureHierarchy()
        configureConstraints()
        configureView()
        bind()
    }
}

extension BaseViewController: NavigationSettings {
    
    @objc func setNavigationBar() {}
}

extension BaseViewController: UISettings {

    @objc func configureHierarchy() {}
    @objc func configureConstraints() {}
    @objc func configureView() {}
}

extension BaseViewController: RxBindSettings {
    
    @objc func bind() {}
}
