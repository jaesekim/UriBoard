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
        
    }
}

extension EditProfileViewController {
    override func setNavigationBar() {
        navigationItem.title = "프로필 수정"
    }
}

extension EditProfileViewController {
    override func bind() {
        
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
            { image, error in
                guard let image = image as? UIImage else { return }
                guard let imgData = image.jpegData(
                    compressionQuality: 0.5
                ) else { return }
                //            self.viewModel.photoData.accept(imgDataList)
            }
        }
    }
}
