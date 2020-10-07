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
        //setNeedsStatusBarAppearanceUpdate()
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
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return ThemeManager.shared.theme?.statusBarStyle ?? .default
//    }
}
