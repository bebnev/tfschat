//
//  ThemeManager.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

//TODO:
class ThemeManagerNew: IThemeManager {
    let themeService: IThemeService
    var theme: ITheme?
    var delegate: IThemeManagerDelegate?
    
    init(themeService: IThemeService) {
        self.themeService = themeService
    }
    
    func load() {
        theme = themeService.fetchTheme() ?? ClassicTheme()
        
        configureGlobalAppearance()
    }
    
    func save(_ theme: ITheme) {
        themeService.save(theme) { [weak self] in
            self?.theme = theme
            DispatchQueue.main.async { [weak self] in 
                self?.delegate?.theme(didApply: theme)
            }
        }
    }
    
    private func configureGlobalAppearance() {
        guard let theme = theme else { return }
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
