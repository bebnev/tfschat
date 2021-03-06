//
//  UINavigationController+applyTheme.swift
//  Chat
//
//  Created by Anton Bebnev on 07.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

extension UINavigationController {
    func applyTheme(theme: ITheme?) {
        guard let theme = theme else {
            return
        }
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: theme.navigationTextColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: theme.navigationTextColor]
            navBarAppearance.backgroundColor = theme.navigatioBackgroundColor

            navigationBar.standardAppearance = navBarAppearance
            navigationBar.compactAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
            //navigationBar.tintColor = theme.navigationTintColor
        } else {
            navigationBar.barTintColor = theme.navigatioBackgroundColor
            // tint color
            navigationBar.isTranslucent = false
            navigationBar.titleTextAttributes = [.foregroundColor: theme.navigationTextColor]
            navigationBar.largeTitleTextAttributes = [.foregroundColor: theme.navigationTextColor]
        }
    }
}
