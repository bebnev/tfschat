//
//  Theme.swift
//  Chat
//
//  Created by Anton Bebnev on 05.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ThemeManager {
    let userThemeKey = "user_theme_key"
    
    var theme: ThemeProtocol?
    
    static var shared: ThemeManager = {
        return ThemeManager()
    }()
    
    func setTheme(theme: ThemeProtocol) {
        self.theme = theme
        
        saveNewTheme(theme)
    }
    
    func saveNewTheme(_ theme: ThemeProtocol) {
        guard let themeTag = Themes(theme: theme) else {
            return
        }
        
        UserDefaults.standard.set(themeTag.rawValue, forKey: userThemeKey)
        UserDefaults.standard.synchronize()
    }
    
    func loadTheme() {
        guard let themeTag = UserDefaults.standard.value(forKey: userThemeKey) as? Int, let theme = Themes(rawValue: themeTag) else {
            setTheme(theme: ClassicTheme())
            return
        }
        
        setTheme(theme: theme.getTheme())
        updateDisplay(theme.getTheme())
    }
    
//    func updateNavigationController(_ navigationController: UINavigationController?) {
//        guard let theme = theme else {
//            return
//        }
//
//        if #available(iOS 13.0, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithTransparentBackground()
//            appearance.backgroundColor = theme.navigatioBackgroundColor
//            appearance.titleTextAttributes = [.foregroundColor: theme.navigationTextColor]
//            appearance.largeTitleTextAttributes = [.foregroundColor: theme.navigationTextColor]
//            navigationController?.navigationBar.standardAppearance = appearance
//            navigationController?.navigationBar.scrollEdgeAppearance = appearance
//            navigationController?.navigationBar.compactAppearance = appearance
//        }
//
//    }
//
//    private func updateDisplay() {
//
//        guard let theme = theme else {
//            return
//        }
//
//        //let sharedApplication = UIApplication.shared
//        //sharedApplication.delegate?.window??.tintColor = theme.mainBackgroundColor
//        if #available(iOS 13.0, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithTransparentBackground()
//            appearance.backgroundColor = theme.navigatioBackgroundColor
//            appearance.titleTextAttributes = [.foregroundColor: theme.navigationTextColor]
//            appearance.largeTitleTextAttributes = [.foregroundColor: theme.navigationTextColor]
//            UINavigationBar.appearance().standardAppearance = appearance
//            UINavigationBar.appearance().scrollEdgeAppearance = appearance
//            UINavigationBar.appearance().compactAppearance = appearance
//        }
////        if #available(iOS 13.0, *) {
////        let appearance = UINavigationBarAppearance()
////        appearance.configureWithOpaqueBackground()
////        appearance.backgroundColor = UIColor.systemRed
////        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText] // With a red background, make the title more readable.
////        navigationItem.standardAppearance = appearance
////        navigationItem.scrollEdgeAppearance = appearance
////        navigationItem.compactAppearance = appearance // For iPhone small navigation bar in landscape.
////        }
////         if #available(iOS 13.0, *) {
////            print("here")
////        let standard = UINavigationBarAppearance()
////
////        //standard.configureWithOpaqueBackground()
////            standard.configureWithOpaqueBackground()
////
////            standard.backgroundColor = theme.navigatioBackgroundColor
////            standard.titleTextAttributes = [.foregroundColor: theme.navigationTextColor]
////            standard.largeTitleTextAttributes = [.foregroundColor: theme.navigationTextColor]
////
////       // let apperance = UINavigationBar.appearance()
////        UINavigationBar.appearance().standardAppearance = standard
////            UINavigationBar.appearance().scrollEdgeAppearance = standard
////        }
////        //UINavigationBar.appearance().backgroundColor = theme.navigatioBackgroundColor
////        apperance.backgroundColor = theme.navigatioBackgroundColor
////
////        var titleAttr = apperance.titleTextAttributes ?? [:]
////        titleAttr.updateValue(theme.navigationTextColor, forKey: .foregroundColor)
////        apperance.titleTextAttributes = titleAttr
////
////        if #available(iOS 13.0, *) {
////            var largeTitleAttr = apperance.largeTitleTextAttributes ?? [:]
////            largeTitleAttr.updateValue(theme.navigationTextColor, forKey: .foregroundColor)
////            apperance.largeTitleTextAttributes = largeTitleAttr
////            apperance.barTintColor = theme.navigatioBackgroundColor
////        }
//    }
}

// MARK:- update UIAppearance

extension ThemeManager {
    func updateDisplay(_ theme: ThemeProtocol) {
        updateNavigationBar(theme)
    }
    
    private func updateNavigationBar(_ theme: ThemeProtocol) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: theme.navigationTextColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: theme.navigationTextColor]
            navBarAppearance.backgroundColor = theme.navigatioBackgroundColor

            
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().compactAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
            UISearchBar.appearance().searchTextField.backgroundColor = theme.searchBarBackgroundColor
        } else {
            UINavigationBar.appearance().barTintColor = theme.navigatioBackgroundColor
            // tint color
            UINavigationBar.appearance().isTranslucent = false
        }
    }
}
