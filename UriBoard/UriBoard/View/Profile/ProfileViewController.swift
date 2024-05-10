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
            profileEditButtonOnClick: mainView.profileEditButton.rx.tap.asObservable(), 
            userId: userId
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
        
        output.followerList
            .map { userList in
                userList.contains { user in
                    user.user_id == UserDefaultsManager.userId
                }
            }
            .drive(with: self) { owner, bool in
                // true이면 이미 상대를 팔로잉한 상태이므로 팔로우 취소 버튼 활성화
                // false이면 상대를 팔로잉하지 않았으므로 팔로우 추가 버튼 활성화
                owner.mainView.followingButton.configuration = .followingButton(status: bool)
                owner.mainView.followingCallBack = {
                    owner.viewModel.followingButtonOnClick.accept(!bool)
                }
            }
            .disposed(by: disposeBag)
    }
}
