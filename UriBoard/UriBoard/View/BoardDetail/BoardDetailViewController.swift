//
//  BoardDetailViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class BoardDetailViewController: BaseViewController {
    
    private let mainView = BoardDetailView()
    
    override func loadView() {
        self.view = mainView
    }
    
    var postId = ""
    var userNickname = ""
    var userId = ""

    private let viewModel = BoardDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillappear!!!!!!!")
        viewModel.viewWillAppearTrigger.onNext(postId)
    }
}

extension BoardDetailViewController {
    override func setNavigationBar() {
        navigationItem.title = userNickname
        setLeftBarButton()
        setRightBarButton()
    }
    private func setLeftBarButton() {
        let leftButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: nil
        )
        leftButton.tintColor = ColorStyle.moreLightDark
        navigationItem.leftBarButtonItem = leftButton
    }
    private func setRightBarButton() {
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: nil
        )
        rightButton.tintColor = ColorStyle.moreLightDark
        navigationItem.rightBarButtonItem = rightButton
    }
}

extension BoardDetailViewController {
    override func bind() {
        
        let input = BoardDetailViewModel.Input(
            postId: postId,
            likeOnClick: mainView.likeButton.rx.tap.asObservable(),
            commentOnClick: mainView.commentButton.rx.tap.asObservable(),
            reboardOnClick: mainView.repeatButton.rx.tap.asObservable(),
            rightNavOnClick: navigationItem.rightBarButtonItem?.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.result
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.mainView.updateUI(success)
                    if success.creator.user_id != UserDefaultsManager.userId {
                        owner.navigationItem.rightBarButtonItem?.isHidden = true
                    }
                case .failure(_):
                    owner.showToast("잠시 후 다시 시도해 주세요")
                }
            }
            .disposed(by: disposeBag)
        
        output.navButtonTrigger
            .drive(with: self) { owner, _ in
                owner.showActionSheet { _ in
                    owner.viewModel.postUpdateTrigger.accept(owner.postId)
                } deleteClosure: { _ in
                    owner.viewModel.postDeleteTrigger.accept(owner.postId)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        owner.showToast("삭제 완료")
                    }
                    
                    owner.dismiss(animated: true)
                }

            }
            .disposed(by: disposeBag)
        
        output.bottomSheetTrigger
            .drive(with: self) { owner, _ in
                let vc = CommentSheetViewController()

                vc.postId = owner.postId
                vc.modalPresentationStyle = .formSheet

                guard let sheet = vc.sheetPresentationController else { return }
                sheet.detents = [.medium(), .large()]
                    sheet.prefersGrabberVisible = true
                
                owner.present(vc, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)

        output.likeList
            .drive(with: self) { owner, list in
                let bool = list.contains(UserDefaultsManager.userId)
                owner.mainView.likeButton.configuration = .iconButton(
                    title: "\(list.count)",
                    systemName: bool ? "heart.fill" : "heart"
                )
            }
            .disposed(by: disposeBag)

        output.reboardList
            .drive(with: self) { owner, list in
                let bool = list.contains(UserDefaultsManager.userId)
                owner.mainView.repeatButton.configuration = .iconButton(
                    title: "\(list.count)",
                    systemName: bool ? "repeat.circle.fill" : "repeat.circle"
                )
            }
            .disposed(by: disposeBag)

        output.errorMessage
            .drive(with: self) { owner, text in
                owner.showToast(text)
            }
            .disposed(by: disposeBag)
        
        mainView.nicknameGestureClosure = { [weak self] in
            guard let self = self else { return }
            
            let vc = ProfileViewController()
            vc.userId = self.userId
            
            self.present(vc, animated: true)
        }
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                print("click")
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}
