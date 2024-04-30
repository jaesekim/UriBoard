//
//  PostViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PostViewController: BaseViewController {

    let mainView = PostView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PostViewController {
    override func setNavigationBar() {
        navigationItem.title = "새로운 보드"
        setLeftBarButton()
        setRightBarButton()
    }
    private func setLeftBarButton() {

        let leftButton = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: nil
        )
        leftButton.tintColor = ColorStyle.darkPurple
        navigationItem.leftBarButtonItem = leftButton
    }
    private func setRightBarButton() {
        let rightButton = UIBarButtonItem(
            title: "등록",
            style: .plain,
            target: self,
            action: nil
        )
        rightButton.tintColor = ColorStyle.darkPurple
        navigationItem.rightBarButtonItem = rightButton
    }
}

extension PostViewController {

    override func bind() {
        
        mainView.nickLabel.text = UserDefaultsManager.nickname

        let a = navigationItem.leftBarButtonItem?.rx.tap.asObservable()
//            .bind(with: self) { owner, _ in
//                print("bar button Click")
//            }
//            .disposed(by: disposeBag)
        mainView.boardTextView.rx
            .didBeginEditing
            .withLatestFrom(mainView.boardTextView.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                if text == "보드를 작성해 주세요!" {
                    owner.mainView.boardTextView.text = nil
                    owner.mainView.boardTextView.textColor = ColorStyle.black
                }
            }
            .disposed(by: disposeBag)

        mainView.boardTextView.rx
            .didEndEditing
            .withLatestFrom(mainView.boardTextView.rx.text.orEmpty)
            .bind(with: self) { owner, text in
                if text.isEmpty {
                    owner.mainView.boardTextView.text = "보드를 작성해 주세요!"
                    owner.mainView.boardTextView.textColor = ColorStyle.black
                }
            }
            .disposed(by: disposeBag)
    }
}
