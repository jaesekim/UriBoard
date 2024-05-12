//
//  PostViewController.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit
import Kingfisher
import PhotosUI
import RxSwift
import RxCocoa

final class PostViewController: BaseViewController {

    let mainView = PostView()

    override func loadView() {
        view = mainView
    }

    private let viewModel = PostViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        
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
        leftButton.tintColor = ColorStyle.moreLightDark
        navigationItem.leftBarButtonItem = leftButton
    }
    private func setRightBarButton() {
        let rightButton = UIBarButtonItem(
            image: UIImage(systemName: "camera.fill"),
            style: .plain,
            target: self,
            action: nil
        )
        rightButton.tintColor = ColorStyle.moreLightDark
        navigationItem.rightBarButtonItem = rightButton
    }
}

extension PostViewController {

    override func bind() {

        let input = PostViewModel.Input(
            rightNavButtonOnclick: navigationItem.rightBarButtonItem?.rx.tap.asObservable(),
            leftNavButtonOnClick: navigationItem.leftBarButtonItem?.rx.tap.asObservable(),
            addContentButtonOnClick: mainView.contentAddButton.rx.tap.asObservable(),
            boardContent: mainView.boardTextView.rx.text.orEmpty.asObservable()
        )

        let output = viewModel.transform(input: input)

        // 게시글 등록 버튼 활성화 유무
        output.addContentButtonValid
            .drive(mainView.contentAddButton.rx.isEnabled)
            .disposed(by: disposeBag)

        // 등록 취소
        output.cancelOnClick
            .drive(with: self) { owner, _ in
                owner.mainView.boardTextView.text = ""
                owner.viewModel.photoData.accept([])
                owner.tabBarController?.selectedIndex = 0
            }
            .disposed(by: disposeBag)

        // 게시글 등록 성공하면 메인화면으로 가기
        output.result
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    owner.showToast("업로드에 성공했습니다")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        owner.mainView.boardTextView.text = ""
                        owner.viewModel.photoData.accept([])
                        owner.tabBarController?.selectedIndex = 0
                    }
                case .failure(let failure):
                    owner.showToast("업로드에 실패했습니다 다시 시도해 주세요")
                }
            }
            .disposed(by: disposeBag)

        // 게시글 등록 실패
        output.errorMessage
            .drive(with: self) { owner, text in
                owner.showToast(text)
            }
            .disposed(by: disposeBag)

        // 사진 추가 버튼 눌렀을 때 로직
        output.addPhotoButtonOnClick
            .drive(with: self) { owner, _ in
                owner.presentPHPicker()
            }
            .disposed(by: disposeBag)
        
        // 선택된 사진 보여주기
        output.photoDataList
            .bind(to: mainView.photoCollectionView.rx.items(
                cellIdentifier: "PostPhotoCollectionViewCell",
                cellType: PostPhotoCollectionViewCell.self)
            ) { (row, element, cell) in
                cell.addedPhoto.image = UIImage(data: element)
            }
            .disposed(by: disposeBag)
        
    }
}
// MARK: 사진 선택 PHPicker
extension PostViewController: PHPickerViewControllerDelegate {

    // PHPicker 열리게 하는 함수
    private func presentPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 4  // 최대한 선택 가능한 사진 숫자
        configuration.filter = .images
        
        let picker = PHPickerViewController(
            configuration: configuration
        )
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let group = DispatchGroup()

        // 데이터 순서 보장을 위한 배열 선언
        var imgDataList = Array(repeating: Data(), count: results.count)
        
        for (idx, item) in results.enumerated() {
            group.enter()
            let itemProvider = item.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self)
                { image, error in
                    guard let image = image as? UIImage else { return }
                    guard let imgData = image.jpegData(
                        compressionQuality: 0.5
                    ) else { return }

                    imgDataList[idx] = imgData

                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }

            self.viewModel.photoData.accept(imgDataList)
        }
    }
}
