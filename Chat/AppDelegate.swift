//
//  AppDelegate.swift
//  Chat
//
//  Created by Anton Bebnev on 15.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let rootAssembly = RootAssembly()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        rootAssembly.presentationAssembly.themeManager.load()
        // TODO: ThemeManager.shared.loadTheme()
        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootAssembly.presentationAssembly.router.toPresent()
        window?.makeKeyAndVisible()
        
// CORE DATA
//        var coreDataStack = CoreDataStack()
//        coreDataStack.enableObservers()
//        coreDataStack.handleDataUpdate = { stack in
//            stack.printDatabaseStatistics()
//        }
        
        return true
    }

}
