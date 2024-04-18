//
//  TabBarController.swift
//  UriBoard
//
//  Created by 김재석 on 4/18/24.
//

import UIKit

class TabBarController: UITabBarController {

    enum TabBarItem: CaseIterable {
        case home
        case post
        case like
        case profile
        
        var screen: UIViewController {
            switch self {
            case .home:
                return HomeViewController()
            case .post:
                return PostViewController()
            case .like:
                return LikeViewController()
            case .profile:
                return ProfileViewController()
            }
        }
        
        var iconInactive: UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "house.scale.up.byLayer")
            case .post:
                return UIImage(systemName: "square.and.pencil.scale.up.byLayer")
            case .like:
                return UIImage(systemName: "heart.scale.up.byLayer")
            case .profile:
                return UIImage(systemName: "person.scale.up.byLayer")
            }
        }
        
        var iconActive: UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "house.fill.scale.up.byLayer")
            case .post:
                return UIImage(systemName: "square.and.pencil.scale.up.byLayer")
            case .like:
                return UIImage(systemName: "heart.fill.scale.up.byLayer")
            case .profile:
                return UIImage(systemName: "person.fill.scale.up.byLayer")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBar()
    }
}

extension TabBarController {

    private func setTabBar() {
        var tabList: [UIViewController] = []
        tabBar.tintColor = ColorStyle.darkBlue
        
        for item in TabBarItem.allCases {
            // NavigationController 달아주기
            let tabVC = UINavigationController(
                rootViewController: item.screen
            )
            
            tabVC.tabBarItem.selectedImage = item.iconActive
            tabVC.tabBarItem.image = item.iconInactive
            
            tabList.append(tabVC)
        }
        viewControllers = tabList
        
        // navigationViewController로 화면 전환 시 탭 사라지지 않도록
        // hidesBottomBarWhenPushed = false
    }
}
