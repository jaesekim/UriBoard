//
//  EditProfileViewController.swift
//  UriBoard
//
//  Created by 김재석 on 5/11/24.
//

import UIKit
import Kingfisher
import PhotosUI
import RxSwift
import RxCocoa


final class EditProfileViewController: BaseViewController {

    let mainView = EditProfileView()

    override func loadView() {
        self.view = mainView
    }

    private let viewModel = EditProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let imgData = mainView.profileImage.image?.jpegData(
            compressionQuality: 1
        ) else { return }
        viewModel.existedImage.accept(imgData)
        viewModel.profileImage.accept(imgData)
    }
}

extension EditProfileViewController {
    override func setNavigationBar() {
        setLeftNavigationItem()
        navigationItem.title = "프로필 수정"
    }
    private func setLeftNavigationItem() {
        let leftItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: nil
        )
        leftItem.tintColor = ColorStyle.lightDark
        navigationItem.leftBarButtonItem = leftItem
    }
}

extension EditProfileViewController {
    override func bind() {
        
        // 화면 전환
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        mainView.profileImageCallback = { [weak self] in

            guard let self = self else { return }
            self.presentPHPicker()
        }
        mainView.deleteImageCallBack = { [weak self] in
            guard let self = self else { return }
            self.viewModel.profileImage.accept(
                UIImage(named: "profile")?.jpegData(
                    compressionQuality: 1
                ) ?? Data()
            )
            self.mainView.profileImage.image = UIImage(
                named: "profile"
            )
        }
        
        
        let input = EditProfileViewModel.Input(
            nickTextField: mainView.nicknameTextField.rx.text.orEmpty.asObservable(),
            confirmButtonOnClick: mainView.confirmButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.updateValidation
            .drive(with: self) { owner, bool in
                owner.mainView.nickGuide.textColor = bool ? ColorStyle.confirm : ColorStyle.reject
                owner.mainView.confirmButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
        output.validationGuide
            .drive(mainView.nickGuide.rx.text)
            .disposed(by: disposeBag)
        
        output.updateCompleteTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(with: self) { owner, text in
                owner.showToast(text)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: 사진 선택 PHPicker
extension EditProfileViewController: PHPickerViewControllerDelegate {

    // PHPicker 열리게 하는 함수
    private func presentPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1  // 최대한 선택 가능한 사진 숫자
        configuration.filter = .images
        
        let picker = PHPickerViewController(
            configuration: configuration
        )
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        
        picker.dismiss(animated: true)

        guard let itemProvider = results.first?.itemProvider else {
            return
        }
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self)
            { [weak self] image, error in
                
                guard let self = self else { return }
                guard let image = image as? UIImage else { return }
                guard let imgData = image.jpegData(
                    compressionQuality: 0.5
                ) else {
                    self.viewModel.profileImage.accept(
                        UIImage(named: "profile")?.jpegData(
                            compressionQuality: 1
                        ) ?? Data()
                    )
                    return
                }
                DispatchQueue.main.async {
                    self.mainView.profileImage.image = image
                    self.viewModel.profileImage.accept(imgData)
                }
            }
        }
    }
}
