//
//  BaseTabBarController.swift
//  LikeAppStore
//
//  Created by ivica petrsoric on 26/04/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavController(viewController: AppsPageController(), title: "Apps", imageName: "apps"),
            createNavController(viewController: AppSearchController(), title: "Search", imageName: "search"),
            createNavController(viewController: UIViewController(), title: "Today", imageName: "today_icon"),
        ]
    }
    
    private func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.image = UIImage(named: imageName)
        viewController.view.backgroundColor = .white
        viewController.navigationItem.title = title
        return navController
    }
    
}
