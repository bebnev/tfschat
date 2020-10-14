//
//  AppDelegate.swift
//  Chat
//
//  Created by Anton Bebnev on 15.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var firstLaunch = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Log.debug("Application is almost ready to run")
        
//        window = UIWindow()
//        
//        window?.makeKeyAndVisible()
//        
//        window?.rootViewController = UINavigationController(rootViewController: ThemesViewController())
        ThemeManager.shared.loadTheme()
        return true
    }
    
    // MARK: App Life-Cycle Events
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if firstLaunch {
            Log.debug("Application moved from not running to inactive and then to active state")
            firstLaunch = false
        } else {
            Log.debug("Application moved from inactive to active state")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Log.debug("Application is moving from active to inactive state")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Log.debug("Application moved from inactive to background state")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Log.debug("Application is moving from background to inactive state")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Log.debug("Application is going to be terminated and moved to not running state")
    }

}

