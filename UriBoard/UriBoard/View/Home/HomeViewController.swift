//
//  HomeViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {

    let mainView = HomeView()
    override func loadView() {
        view = mainView
    }

    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppearTrigger.accept(())
    }
}

extension HomeViewController {
    override func setNavigationBar() {
        super.setNavigationBar()

        navigationItem.title = "홈"
    }
    
}

extension HomeViewController {
    override func bind() {
        
        let queryString = BehaviorSubject(
            value: ReadPostsQueryString(
                next: nil, limit: "10"
            )
        )
        let postItems = PublishSubject<[ReadDetailPostModel]>()
        var postData: [ReadDetailPostModel] = []
        var totalPages = 0
        var nextCursor = ""

        let input = HomeViewModel.Input(
            readPostsQueryString: queryString.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.result
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    postData.append(contentsOf: success.data)
                    totalPages += success.data.count
                    postItems.onNext(postData)
                    nextCursor = success.cursor
                case .failure(let failure):
                    owner.showToast("잠시 후 다시 시도해 주세요")
                }
            }
            .disposed(by: disposeBag)
        
        postItems
            .bind(to: mainView.boardTableView.rx.items(
                cellIdentifier: "BoardTableViewCell",
                cellType: BoardTableViewCell.self)
            ) { (row, element, cell) in

                cell.updateUI(element)
                cell.selectionStyle = .none

                // cursor pagination
                print("totalPages: ", totalPages)
                if row == totalPages - 2 && nextCursor != "0" {
                    queryString.onNext(
                        ReadPostsQueryString(
                            next: nextCursor,
                            limit: "10"
                        )
                    )
                }
                
                
                let input = BoardTableViewModel.Input(
                    likeOnClick: cell.likeButton.rx.tap.asObservable(),
                    reboardOnClick: cell.repeatButton.rx.tap.asObservable(),
                    postId: element.id
                )
                
                let output = cell.viewModel.transform(input: input)

                output.likeList
                    .drive(with: self) { owner, list in
                        let bool = list.contains(UserDefaultsManager.userId)
                        cell.likeButton.configuration = .iconButton(
                            title: "\(list.count)",
                            systemName: bool ? "heart.fill" : "heart"
                        )
                    }
                    .disposed(by: cell.disposeBag)
                
                output.reboardList
                    .drive(with: self) { owner, list in
                        let bool = list.contains(UserDefaultsManager.userId)
                        cell.repeatButton.configuration = .iconButton(
                            title: "\(list.count)",
                            systemName: bool ? "repeat.circle.fill" : "repeat.circle"
                        )
                    }
                    .disposed(by: cell.disposeBag)

                output.errorMessage
                    .drive(with: self) { owner, text in
                        owner.showToast(text)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(
            mainView.boardTableView.rx.itemSelected,
            mainView.boardTableView.rx.modelSelected(
                ReadDetailPostModel.self
            )
        )
        .map { $0.1 }
        .bind(with: self) { owner, value in
            let vc = BoardDetailViewController()

            vc.postId = value.id
            vc.userNickname = value.creator.nick
            vc.hidesBottomBarWhenPushed = true
            
            owner.navigationController?.pushViewController(
                vc, animated: true
            )
        }
        .disposed(by: disposeBag)
            
        
//        mainView.boardTableView.rx
//            .prefetchRows
//            .compactMap(\.last?.row)
//            .bind(with: self) { owner, index in
////                print(last)
//                print(nextCursor)
//                print("totalPages: ", totalPages)
//                print(index)
//                print(postData[index])
//                if index == totalPages - 3 && nextCursor != "0" {
//                    queryString.onNext(
//                        ReadPostsQueryString(
//                            next: nextCursor,
//                            limit: "10"
//                        )
//                    )
//                }
//            }
//            .disposed(by: disposeBag)
    }
}
