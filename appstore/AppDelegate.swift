//
//  AppDelegate.swift
//  appstore
//
//  Created by Paul Dong on 7/10/17.
//  Copyright © 2017 Paul Dong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
//        let layout = UICollectionViewFlowLayout()
//        let featuredAppsController = FeaturedAppsController(collectionViewLayout: layout)
//
//        window?.rootViewController = UINavigationController(rootViewController: featuredAppsController)
        
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [
            createTabBarController(controller: FeaturedAppsController(collectionViewLayout: UICollectionViewFlowLayout()), title: "Featured", imageName: "recent"),
            createTabBarController(controller: UIViewController(),title: "Calls", imageName: "calls"),
            createTabBarController(controller: UIViewController(),title: "Groups", imageName: "groups"),
            createTabBarController(controller: UIViewController(),title: "People", imageName: "people"),
            createTabBarController(controller: UIViewController(), title: "Settings", imageName:  "settings")
        ]
        
        window?.rootViewController = tabBarController
        
        return true
    }
    
    private func createTabBarController(controller: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: controller)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

