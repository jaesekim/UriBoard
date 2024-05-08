//
//  ImageLayoutView.swift
//  UriBoard
//
//  Created by 김재석 on 5/5/24.
//

import UIKit
import SnapKit
import Kingfisher
import Then

class ImageLayoutView: BaseView {
    let imageView1 = {
        let view = UIImageView(frame: .zero)
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    let imageView2 = UIImageView(frame: .zero).then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    let imageView3 = UIImageView(frame: .zero).then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    let imageView4 = UIImageView(frame: .zero).then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var imageViews = [
        imageView1,
        imageView2,
        imageView3,
        imageView4,
    ]
}

extension ImageLayoutView {
    override func configureView() {
        [
            imageView1,
            imageView2,
            imageView3,
            imageView4,
        ].forEach { addSubview($0) }
    }
}

extension ImageLayoutView: KingfisherModifier {
    func updateImagesLayout(_ imgURLs: [String]) {
        
        // 레이아웃 초기화하고 시작
        imageViews.forEach { $0.snp.removeConstraints() }

        for (idx, imgURL) in imgURLs.enumerated() {
            let url = APIURL.baseURL + "/v1/" + imgURL
            imageViews[idx].kf.setImage(
                with: URL(string: url),
                placeholder: UIImage(systemName: "xmark"),
                options: [.requestModifier(modifier)]
            )
        }

        switch imgURLs.count {
        case 1:
            return singleImage()
        case 2:
            return doubleImages()
        case 3:
            return tripleImages()
        case 4:
            return quadImages()
        default:
            return
        }
    }
}

// MARK: Image 개수에 따라 레이아웃 다르게 보여주기
extension ImageLayoutView {
    private func singleImage() {
        
        for idx in 0...0 { imageViews[idx].isHidden = false }
        for idx in 1...3 { imageViews[idx].isHidden = true }
        imageView1.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    private func doubleImages() {

        for idx in 0...1 { imageViews[idx].isHidden = false }
        for idx in 2...3 { imageViews[idx].isHidden = true }

        imageView1.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(self)
            make.width.equalTo(self).dividedBy(2)
        }
        imageView2.snp.makeConstraints { make in
            make.trailing.verticalEdges.equalTo(self)
            make.width.equalTo(self).dividedBy(2)
        }
    }
    private func tripleImages() {

        for idx in 0...2 { imageViews[idx].isHidden = false }
        for idx in 3...3 { imageViews[idx].isHidden = true }

        imageView1.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(self)
            make.width.equalTo(self).dividedBy(3)
        }
        imageView2.snp.makeConstraints { make in
            make.leading.equalTo(imageView1.snp.trailing)
            make.verticalEdges.equalTo(self)
            make.width.equalTo(self).dividedBy(3)
        }
        imageView3.snp.makeConstraints { make in
            make.leading.equalTo(imageView2.snp.trailing)
            make.verticalEdges.equalTo(self)
            make.width.equalTo(self).dividedBy(3)
        }
    }
    private func quadImages() {
        
        for idx in 0...3{
            imageViews[idx].isHidden = false
        }
        imageView1.snp.makeConstraints { make in
            make.leading.top.equalTo(self)
            make.width.height.equalTo(self).dividedBy(2)
        }
        imageView2.snp.makeConstraints { make in
            make.trailing.top.equalTo(self)
            make.width.height.equalTo(self).dividedBy(2)
        }
        imageView3.snp.makeConstraints { make in
            make.leading.bottom.equalTo(self)
            make.width.height.equalTo(self).dividedBy(2)
        }
        imageView4.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self)
            make.width.height.equalTo(self).dividedBy(2)
        }
    }
}
