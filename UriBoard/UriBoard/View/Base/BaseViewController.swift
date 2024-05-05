//
//  BaseViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/10/24.
//

import UIKit
import Kingfisher
import RxSwift
import Toast

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let modifier = AnyModifier { request in
        var request = request
        request.setValue(
            HTTPHeader.json.rawValue,
            forHTTPHeaderField: HTTPHeader.contentType.rawValue
        )
        request.setValue(
            APIKey.key,
            forHTTPHeaderField: HTTPHeader.sesacKey.rawValue
        )
        request.setValue(
            UserDefaultsManager.accessToken,
            forHTTPHeaderField: HTTPHeader.auth.rawValue
        )
        return request
    }
    
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
    
    func showActionSheet(
        updateClosure: ((UIAlertAction) -> Void)?,
        deleteClosure: ((UIAlertAction) -> Void)?
    ) {
        
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let update = UIAlertAction(
            title: "댓글 수정",
            style: .default,
            handler: updateClosure
        )
        let delete = UIAlertAction(
            title: "댓글 삭제",
            style: .default,
            handler: deleteClosure
        )
        let cancel = UIAlertAction(
            title: "취소",
            style: .cancel
        )
        alert.addAction(update)
        alert.addAction(cancel)
        alert.addAction(cancel)
        
        present(alert, animated:true)
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
