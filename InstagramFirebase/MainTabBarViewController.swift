//
//  MainTabBarViewController.swift
//  InstagramFirebase
//
//  Created by Will Wang on 11/23/18.
//  Copyright © 2018 Will Wang. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)

            present(navController, animated: true, completion: nil)
            return false
        }
        
        
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self //UITabBarControllerDelegate
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            
            return
        }
        
        setupViewController()
        
    }
    
    func setupViewController() {
        
        //home
        let homeNavController = templateNavController(selectedImage: #imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //search
        let searchController = templateNavController(selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"))
        
        //plus
        let plusController = templateNavController(selectedImage: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        //likeController
        let likeController = templateNavController(selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"))
        
        //userProfile
        let userProfileController = templateNavController(selectedImage: #imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        tabBar.tintColor = UIColor.black
        
        viewControllers = [homeNavController,
                           searchController,
                           plusController,
                           likeController,
                           userProfileController]
        
        tabBar.items?.forEach {
            $0.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        }
    }

    fileprivate func templateNavController(selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.image = unselectedImage
        return navController
    }
    

}
