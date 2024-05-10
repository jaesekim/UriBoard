//
//  ProfileView.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class ProfileView: BaseView {
    
    let imageLayoutView = UIView()

    let profileImage = UIImageView(frame: .zero).then {
        $0.image = UIImage(systemName: "person")
        $0.tintColor = ColorStyle.lightDark
    }
    let nicknameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
        $0.text = "Jess"
    }

    let postStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 8
        
    }
    let postCounts = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
        $0.text = "0"
        $0.textAlignment = .center
    }
    let postGuide = UILabel().then {
        $0.text = "게시물"
        $0.font = .systemFont(ofSize: 17)
        $0.textAlignment = .center
    }
    
    let followersStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    let followersCounts = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
        $0.text = "0"
        $0.textAlignment = .center
    }
    let followersGuide = UILabel().then {
        $0.text = "팔로워"
        $0.font = .systemFont(ofSize: 17)
        $0.textAlignment = .center
    }
    
    let followingsStack = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    let followingsCounts = UILabel().then {
        $0.font = .systemFont(ofSize: 17)
        $0.text = "0"
        $0.textAlignment = .center
    }
    let followingsGuide = UILabel().then {
        $0.text = "팔로잉"
        $0.font = .systemFont(ofSize: 17)
        $0.textAlignment = .center
    }
    
    let profileStatusStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 16
    }
    
    let lineView = UIView().then {
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1.5
    }
    
    let buttonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 0
    }
    
    let totalPostButton = UIButton().then {
        $0.configuration = .iconButton(
            title: nil,
            systemName: "square.grid.2x2"
        )
    }
    let likePostButton = UIButton().then {
        $0.configuration = .iconButton(
            title: nil,
            systemName: "heart"
        )
    }
    let reboardPostButton = UIButton().then {
        $0.configuration = .iconButton(
            title: nil,
            systemName: "repeat"
        )
    }

    let totalPostTable = UITableView().then {
        $0.register(
            TotalPostTableViewCell.self,
            forCellReuseIdentifier: "TotalPostTableViewCell"
        )
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 200
    }
    let likePostTable = UITableView().then {
        $0.register(
            LikePostTableViewCell.self,
            forCellReuseIdentifier: "LikePostTableViewCell"
        )
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 200
    }
    let reboardPostTable = UITableView().then {
        $0.register(
            ReboardPostTableViewCell.self,
            forCellReuseIdentifier: "ReboardPostTableViewCell"
        )
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 200
    }
}

extension ProfileView {
    override func configureHierarchy() {
        [
            imageLayoutView,
            nicknameLabel,
            profileStatusStack,
            lineView,
            buttonStack,
            totalPostTable,
            likePostTable,
            reboardPostTable
        ].forEach { addSubview($0) }
    
        imageLayoutView.addSubview(profileImage)

        [
            postCounts,
            postGuide
        ].forEach { postStack.addArrangedSubview($0) }

        [
            followersCounts,
            followersGuide,
        ].forEach { followersStack.addArrangedSubview($0) }

        [
            followingsCounts,
            followingsGuide,
        ].forEach { followingsStack.addArrangedSubview($0) }

        [
            postStack,
            followersStack,
            followingsStack
        ].forEach { profileStatusStack.addArrangedSubview($0) }
        
        [
            totalPostButton,
            likePostButton,
            reboardPostButton,
        ].forEach { buttonStack.addArrangedSubview($0) }
        
    }
    override func configureConstraints() {
        print(#function)
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.height.lessThanOrEqualTo(40)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().inset(16)
        }
        imageLayoutView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(32)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(16)
            $0.height.width.equalTo(80)
        }
        profileImage.snp.makeConstraints {
            $0.edges.equalTo(imageLayoutView)
        }
        
        // 프로필 상태 스택
        profileStatusStack.snp.makeConstraints { make in
            make.centerY.equalTo(imageLayoutView.snp.centerY)
            make.height.equalTo(48)
            make.leading.equalTo(imageLayoutView.snp.trailing).offset(28)
            make.trailing.equalToSuperview().offset(-28)
        }
        
        // 게시물 개수 스택
//        postStack.snp.makeConstraints { make in
//            make.width.lessThanOrEqualTo(60)
//        }
        postCounts.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        postGuide.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        // 팔로워 수 스택
//        followersStack.snp.makeConstraints { make in
//            make.width.lessThanOrEqualTo(60)
//        }
        followersCounts.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        followersGuide.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        // 팔로잉 수 스택
//        followingsStack.snp.makeConstraints { make in
//            make.width.lessThanOrEqualTo(60)
//        }
        followingsCounts.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        followingsGuide.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(profileStatusStack.snp.bottom).offset(32)
        }
        
        // 버튼 스택
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        totalPostTable.snp.makeConstraints { make in
            make.top.equalTo(buttonStack).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        likePostTable.snp.makeConstraints { make in
            make.top.equalTo(buttonStack).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        reboardPostTable.snp.makeConstraints { make in
            make.top.equalTo(buttonStack).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
    override func configureView() {
        super.configureView()
        print(#function)
        imageLayoutView.layer.cornerRadius = 40
        imageLayoutView.clipsToBounds = true
        imageLayoutView.contentMode = .scaleAspectFill
        imageLayoutView.layer.borderColor = ColorStyle.lightDark.cgColor
        imageLayoutView.layer.borderWidth = 1
        imageLayoutView.backgroundColor = .lightGray
    }
}

// MARK: StackView 관리
extension ProfileView: KingfisherModifier {
    func updateUI(_ element: ProfileModel) {

        let imgUrl = APIURL.baseURL + "/v1/" + (element.profileImage ?? "")

        nicknameLabel.text = element.nick
        profileImage.kf.setImage(
            with: URL(string: imgUrl),
            placeholder: UIImage(systemName: "person"),
            options: [.requestModifier(modifier)]
        )
        postCounts.text = "\(element.posts.count)"
        followersCounts.text = "\(element.followers.count)"
        followingsCounts.text = "\(element.following.count)"
    }
}
