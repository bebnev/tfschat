//
//  SettingsViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 06.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

protocol ThemesPickerDelegate: class {
    func selectTheme(theme: ThemeProtocol)
}

class ThemesViewController: BaseViewController {
    
    // Потенциальная проблема при использовании делегата - если сам делегат объявлен как сильная ссылка, то получается ThemesViewController будет держать сильную ссылку
    // на ConversationsListViewController и соответсвенно ConversationsListViewController держит сильную ссылку на ThemesViewController - это может привести к зацикливанию.
    // Решение - преобразовать ссылку на слабую
    
    weak var delegate: ThemesPickerDelegate?
    var selectTheme: ((_ theme: ThemeProtocol) -> Void)?
    
    lazy var classicThemeView: ThemeButtonView = {
        let classic = ThemeButtonView()
        classic.buttonLabelText = "Classic"
        classic.leftImageContent = UIImage(named: "classic-left")
        classic.rightImageContent = UIImage(named: "classic-right")
        classic.translatesAutoresizingMaskIntoConstraints = false
        classic.onHandleTouch = handleThemeButtonTouch(_:)
        classic.tag = Themes.classic.rawValue
        
        return classic
    }()
    
    lazy var dayThemeView: ThemeButtonView = {
        let day = ThemeButtonView()
        day.buttonLabelText = "Day"
        day.leftImageContent = UIImage(named: "day-left")
        day.rightImageContent = UIImage(named: "day-right")
        day.translatesAutoresizingMaskIntoConstraints = false
        day.onHandleTouch = handleThemeButtonTouch(_:)
        day.tag = Themes.day.rawValue
        
        return day
    }()
    
    lazy var nightThemeView: ThemeButtonView = {
        let night = ThemeButtonView()
        night.buttonLabelText = "Night"
        night.leftImageContent = UIImage(named: "night-left")
        night.rightImageContent = UIImage(named: "night-right")
        night.translatesAutoresizingMaskIntoConstraints = false
        night.onHandleTouch = handleThemeButtonTouch(_:)
        night.tag = Themes.night.rawValue

        return night
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
        ThemeManager.shared.setTheme(theme: theme)
        applyTheme(theme: theme)
        
        if let delegate = delegate {
            delegate.selectTheme(theme: theme)
        } else if let selectTheme = selectTheme {
            selectTheme(theme)
        }
    }
    
    override func applyTheme(theme: ThemeProtocol) {
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
