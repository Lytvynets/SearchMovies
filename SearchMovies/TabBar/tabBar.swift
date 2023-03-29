//
//  tabBar.swift
//  SearchMovies
//
//  Created by Vlad Lytvynets on 27.03.2023.
//

import Foundation
import UIKit

class TabBarVC: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .black
        // tabBar.unselectedItemTintColor = .red
        tabBar.backgroundColor = #colorLiteral(red: 0.9373161197, green: 0.937415421, blue: 0.9404873252, alpha: 1)
        setup()
    }
    
    
    func setup(){
        viewControllers = [
            createNavController(rootVC: SearchViewController(), title: "Search", image: UIImage(systemName: "magazine.fill")!),
            createNavController(rootVC: SelectedViewController(), title: "Selected", image: UIImage(systemName: "bookmark.fill")!),
            createNavController(rootVC: ProfileViewController(), title: "Prifile", image: UIImage(systemName: "person.fill")!),
        ]
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //  tabBar.tintColor = SetColors.currentColor.labelsColor
        //  self.tabBar.backgroundColor = .systemGray
        //  self.tabBar.barTintColor = SetColors.currentColor.backgroundCustomViewColor
    }
    
    
    func createNavController (rootVC: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootVC)
        navController.tabBarItem.image = image
        //  navController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: SetColors.currentColor.labelsColor]
        navController.navigationBar.prefersLargeTitles = true
        rootVC.navigationItem.title = title
        return navController
    }
}
