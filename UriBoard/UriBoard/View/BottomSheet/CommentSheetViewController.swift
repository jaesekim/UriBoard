//
//  CommentSheetViewController.swift
//  UriBoard
//
//  Created by 김재석 on 5/4/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class CommentSheetViewController: BaseViewController {
    
    let mainView = CommentSheetView()
    override func loadView() {
        self.view = mainView
    }

    var postId = ""

    private let viewModel = CommentSheetViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.screenUpdateTrigger.accept(())
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension CommentSheetViewController {
    override func bind() {
        
        let input = CommentSheetViewModel.Input(
            commentText: mainView.commentTextField.rx.text.orEmpty.asObservable(),
            sendButtonOnClick: mainView.sendButton.rx.tap.asObservable(),
            postId: postId
        )
        let output = viewModel.transform(input: input)
        
        output.sendButtonStatus
            .drive(mainView.sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.commentList
            .bind(to: mainView.commentsTable.rx.items(
                cellIdentifier: "CommentTableViewCell",
                cellType: CommentTableViewCell.self)
            ) { (row, element, cell) in
                cell.updateUI(element)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        output.doneTirgger
            .drive(with: self) { owner, _ in
                owner.mainView.commentTextField.text = ""
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(with: self) { owner, text in
                owner.showToast(text)
            }
            .disposed(by: disposeBag)
        
        

    }
}

