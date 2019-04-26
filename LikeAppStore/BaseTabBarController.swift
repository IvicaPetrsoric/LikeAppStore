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
        
        let redViewController = UIViewController()
        redViewController.view.backgroundColor = .red
        redViewController.navigationItem.title = "Apps"
        
        let redNavController = UINavigationController(rootViewController: redViewController)
        redNavController.tabBarItem.title = "Rev nav"
        redNavController.navigationBar.prefersLargeTitles = true
        
        let blueViewController = UIViewController()
        blueViewController.view.backgroundColor = .blue
        blueViewController.navigationItem.title = "Search"
        
        let blueNavController = UINavigationController(rootViewController: blueViewController)
        blueNavController.tabBarItem.title = "blue nav"
        blueNavController.navigationBar.prefersLargeTitles = true

        viewControllers = [
            redNavController,
            blueNavController
        ]
    }
    
}
