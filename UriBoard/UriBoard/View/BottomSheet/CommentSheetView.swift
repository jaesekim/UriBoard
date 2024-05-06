//
//  CommentSheetView.swift
//  UriBoard
//
//  Created by 김재석 on 5/5/24.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import SnapKit
import Then

class CommentSheetView: BaseView {

    let commentsTable = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 60
        $0.backgroundColor = .clear
        $0.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: "CommentTableViewCell"
        )
        $0.showsVerticalScrollIndicator = false
    }
    let noCommentLabel = UILabel().then {
        $0.text = "댓글이 없습니다!"
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textAlignment = .center
    }
    let commentTextField = UITextField.addLeftPadding(
        placeholder: "댓글 작성"
    )
    let sendButton = UIButton().then {
        $0.configuration = .iconButton(
            title: nil,
            systemName: "paperplane.fill"
        )
    }
}

extension CommentSheetView: KingfisherModifier {
    func updateUI() {}
}

extension CommentSheetView {
    override func configureHierarchy() {
        [
            commentsTable,
            commentTextField,
            noCommentLabel,
            sendButton,
        ].forEach { addSubview($0) }
    }
    override func configureConstraints() {
        commentsTable.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(commentTextField.snp.top).offset(-20)
        }
        noCommentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-44)
        }
        commentTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(sendButton.snp.leading).offset(-4)
        }
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    override func configureView() {
        backgroundColor = .white
    }
}
