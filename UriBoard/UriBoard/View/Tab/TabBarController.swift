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
//        case search
        case post
        case pay
        case profile
        
        var screen: UIViewController {
            switch self {
            case .home:
                return HomeViewController()
//            case .search:
//                return SearchViewController()
            case .post:
                return PostViewController()
            case .pay:
                return PaymentsViewController()
            case .profile:
                return ProfileViewController()
            }
        }
        
        var iconInactive: UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "house")
//            case .search:
//                return UIImage(systemName: "number")
            case .post:
                return UIImage(systemName: "plus.square")
            case .pay:
                return UIImage(systemName: "creditcard")
            case .profile:
                return UIImage(systemName: "person")
            }
        }
        
        var iconActive: UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "house")
//            case .search:
//                return UIImage(systemName: "number")
            case .post:
                return UIImage(systemName: "plus.square.fill")
            case .pay:
                return UIImage(systemName: "creditcard.fill")
            case .profile:
                return UIImage(systemName: "person.fill")
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
        tabBar.tintColor = ColorStyle.moreLightDark
        
        for item in TabBarItem.allCases {
            // NavigationController 달아주기
            if item == .pay || item == .home || item == .profile {
                let tabVC = item.screen
                
                tabVC.tabBarItem.selectedImage = item.iconActive
                tabVC.tabBarItem.image = item.iconInactive

                tabList.append(tabVC)
            } else {
                let tabVC = UINavigationController(
                    rootViewController: item.screen
                )
                
                tabVC.tabBarItem.selectedImage = item.iconActive
                tabVC.tabBarItem.image = item.iconInactive

                tabList.append(tabVC)
            }
        }
        viewControllers = tabList
        
        // navigationViewController로 화면 전환 시 탭 사라지지 않도록
         
    }
}
