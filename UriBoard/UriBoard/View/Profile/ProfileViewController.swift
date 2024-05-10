//
//  ProfileViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: BaseViewController {

    let mainView = ProfileView()
    override func loadView() {
        self.view = mainView
    }
    
    var userId = UserDefaultsManager.userId
    private let viewModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppearTrigger.accept(userId)
    }

}

extension ProfileViewController {
    override func setNavigationBar() {
        navigationItem.title = "프로필"
    }
}

extension ProfileViewController {
    override func bind() {
        let input = ProfileViewModel.Input(
            profileEditButtonOnClick: mainView.profileEditButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.result
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.mainView.updateUI(success)
                case .failure(let failure):
                    owner.showToast("Error: \(failure.rawValue) 잠시 후 다시 시도해 주세요")
                }
                
            }
            .disposed(by: disposeBag)
        
        output.profileEditButtonTrigger
            .drive(with: self) { owner, _ in
                let vc = EditProfileViewController()

                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                
                owner.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
