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
        
        DispatchQueue.global().async {[weak self] in
            guard let key = self?.userThemeKey else {
                return
            }
            
            UserDefaults.standard.set(themeTag.rawValue, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    func loadTheme() {
        guard let themeTag = UserDefaults.standard.value(forKey: userThemeKey) as? Int, let theme = Themes(rawValue: themeTag) else {
            setTheme(theme: ClassicTheme())
            return
        }
        
        setTheme(theme: theme.getTheme())
        updateDisplay(theme.getTheme())
    }
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
            //UINavigationBar.appearance().tintColor = theme.navigationTintColor
            UISearchBar.appearance().searchTextField.backgroundColor = theme.searchBarBackgroundColor
            
        } else {
            UINavigationBar.appearance().barTintColor = theme.navigatioBackgroundColor
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: theme.navigationTextColor]
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: theme.navigationTextColor]
            // tint color
            UINavigationBar.appearance().isTranslucent = false
            
        }
        
        UISearchBar.appearance().textField?.backgroundColor = UIColor.red
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.systemPink
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.red
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
    }
}
