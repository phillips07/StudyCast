//
//  CustomTabBarController.swift
//  StudyCast
//
//  Created by Dennis Huebert on 2016-11-11.
//  Copyright © 2016 Austin Phillips. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let groupsContoller = UIViewController()
        let groupsNavigationController = UINavigationController(rootViewController: groupsContoller)
        groupsNavigationController.title = "Groups"
        //add icon for friends here
        //friendsNavigationController.tabBarItem.image = UIImage(named: "friends_icon")
        
        //change castContoller to different view later
        let castController = UIViewController()
        let castNavigationController = UINavigationController(rootViewController: castController)
        castNavigationController.title = "Cast"
        //add icon for cast here
        //castNavigationController.tabBarItem.image = UIImage(named: "cast_icon")
        
        let homeController = MainScreenController()
        let homeNavigationController = UINavigationController(rootViewController: homeController)
        homeNavigationController.title = "Home"
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGray], for: .selected)
        
        viewControllers = [homeNavigationController, castNavigationController, groupsNavigationController]
    }
}
