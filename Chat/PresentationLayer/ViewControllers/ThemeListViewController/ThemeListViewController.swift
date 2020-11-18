//
//  SettingsViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 06.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ThemeListViewController: AbstractViewController {
    
    lazy var classicThemeView: ThemeButtonView = {
        return createThemeButton(name: "Classic", leftImage: UIImage(named: "classic-left"), rightImage: UIImage(named: "classic-right"), tag: Themes.classic.rawValue)
    }()
    
    lazy var dayThemeView: ThemeButtonView = {
        return createThemeButton(name: "Day", leftImage: UIImage(named: "day-left"), rightImage: UIImage(named: "day-right"), tag: Themes.day.rawValue)
    }()
    
    lazy var nightThemeView: ThemeButtonView = {
        return self.createThemeButton(name: "Night", leftImage: UIImage(named: "night-left"), rightImage: UIImage(named: "night-right"), tag: Themes.night.rawValue)
    }()
    
    lazy var availableThemes: Array = {
        return [self.classicThemeView, self.dayThemeView, self.nightThemeView]
    }()
    
    lazy var contentView: UIStackView = {
        let view = UIStackView(arrangedSubviews: self.availableThemes)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 40
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupView()
        setupLayout()
    }
    
    func setupNavigation() {
        title = "Settings"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupView() {
        
        view.addSubview(contentView)
    }
    
    func createThemeButton(name: String, leftImage: UIImage?, rightImage: UIImage?, tag: Int) -> ThemeButtonView {
        let button = ThemeButtonView()
        button.buttonLabelText = name
        button.leftImageContent = leftImage
        button.rightImageContent = rightImage
        button.translatesAutoresizingMaskIntoConstraints = false
        button.onHandleTouch = handleThemeButtonTouch(_:)
        button.tag = tag

        return button
    }
    
    func setupLayout() {
        let constraints = [
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38)

        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc
    func handleThemeButtonTouch(_ tag: Int) {
        guard let theme = Themes(rawValue: tag)?.getTheme() else {
            return
        }
        presentationAssembly?.themeManager.save(theme)
        applyTheme(theme: theme)
    }
    
    override func applyTheme(theme: ITheme) {
        guard let themeTag = Themes(theme: theme) else {
            return
        }
        
        for themeView in availableThemes {
            themeView.isSelected = themeView.tag == themeTag.rawValue
        }
        
        view.backgroundColor = theme.themeVCBackgroundColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
