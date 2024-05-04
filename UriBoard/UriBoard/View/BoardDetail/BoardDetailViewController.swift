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

    private let viewModel = BoardDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.viewWillAppearTrigger.onNext(postId)
    }
}

extension BoardDetailViewController {
    override func setNavigationBar() {
        navigationItem.title = userNickname
    }
}

extension BoardDetailViewController {
    override func bind() {
        
        let input = BoardDetailViewModel.Input(
            postId: postId,
            likeOnClick: mainView.likeButton.rx.tap.asObservable(),
            commentOnClick: mainView.commentButton.rx.tap.asObservable(),
            reboardOnClick: mainView.repeatButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.result
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.mainView.updateUI(success)
                case .failure(_):
                    owner.showToast("잠시 후 다시 시도해 주세요")
                }
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
    }
}
