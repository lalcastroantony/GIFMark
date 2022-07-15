//
//  TabBarItemsHelper.swift
//  GIFMark
//
//  Created by lal-7695 on 15/07/22.
//

import Foundation
import UIKit

/// This is a helper class for defining ``HomeTabBarViewController``'s ViewControllers
class TabBarItemsHelper {
    private init(){}
    static let sharedInstance = TabBarItemsHelper()
    
    
    /// This is a array tuple contains viewcontrollers, their tabbar image names and titles
    var tabBarItems: [(vc: UIViewController, image: String, title: String)] {
        let listVC = UINavigationController.init(rootViewController: GIFListViewController())
        let favouritesVC = UINavigationController.init(rootViewController: FavouritesViewController())
        let tabBarItems: [(vc: UIViewController, image: String, title: String)] = [(listVC, "photo.on.rectangle", "ListView.title"), (favouritesVC, "heart", "FavouritesView.title")]
        return tabBarItems
    }
}
