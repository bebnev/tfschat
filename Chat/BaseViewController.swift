//
//  ViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 15.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var previousTheme: ThemeProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        Log.debug("View is loaded into memory")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Log.debug("View is moving from disappeared to appearing state")
        if let theme = ThemeManager.shared.theme {
            applyTheme(theme: theme)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Log.debug("View moved from appearing to appeared state")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        Log.debug("View is going to layout it subviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Log.debug("View has laid it subviews")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Log.debug("View is moving from appeared to disappearing state")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Log.debug("View moved from disappearing to disappeared state")
    }
    
    func applyTheme(theme: ThemeProtocol) {
        view.backgroundColor = theme.mainBackgroundColor
    }
}
//
//extension BaseViewController {
//    func viewDidChangeTheme(_ theme: ThemeProtocol) {
//        applyThemeToNavigationController(theme)
//        applyThemeToVCView(theme)
//    }
//
//    private func applyTheme() {
//        guard let theme = ThemeManager.shared.theme else {
//            return
//        }
//
//        viewDidChangeTheme(theme)
//    }
//
//    private func applyThemeToNavigationController(_ theme: ThemeProtocol) {
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
//    }
//
//    private func applyThemeToVCView(_ theme: ThemeProtocol) {
//        view.backgroundColor = theme.mainBackgroundColor
//    }
//}
