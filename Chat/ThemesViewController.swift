//
//  SettingsViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 06.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

protocol ThemesPickerDelegate {
    func selectTheme(theme: ThemeProtocol)
}

class ThemesViewController: BaseViewController {
    
    var delegate: ThemesPickerDelegate?
    
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
    
    lazy var contentView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.classicThemeView, self.dayThemeView, self.nightThemeView])
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
        title = "Themes"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(contentView)
    }
    
    func setupLayout() {
        let constraints = [
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),

        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc
    func handleThemeButtonTouch(_ tag: Int) {
        print(tag)
    }
    
//    private func setupView() {
//        view.addSubview(buttonDarkTheme)
//        view.addSubview(buttonClassicTheme)
//        view.backgroundColor = .white
//    }
//
//    private func setupLayout() {
//        let constraints = [
//            buttonDarkTheme.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
//            buttonDarkTheme.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
//            buttonDarkTheme.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
//            buttonDarkTheme.heightAnchor.constraint(equalToConstant: 40),
//            buttonClassicTheme.topAnchor.constraint(equalTo: buttonDarkTheme.bottomAnchor, constant: 40),
//            buttonClassicTheme.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
//            buttonClassicTheme.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
//            buttonClassicTheme.heightAnchor.constraint(equalToConstant: 40)
//        ]
//        NSLayoutConstraint.activate(constraints)
//
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        print("123")
//    }
//
    @objc
    func buttonAction(sender: UIButton) {
       // print(sender.isHighlighted)
        
        sender.layer.borderWidth = 10
        sender.layer.borderColor = UIColor.red.cgColor
//        print(sender.tag)
//        guard let theme = Themes(rawValue: sender.tag) else {
//            return
//        }
//
//        ThemeManager.shared.setTheme(theme: theme.getTheme())
//        navigationController?.popViewController(animated: true)
    }

}

class MyButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            switch isHighlighted {
            case true:
                layer.borderColor = UIColor.blue.cgColor
                layer.borderWidth = 2
            case false:
                layer.borderColor = UIColor.lightGray.cgColor
                layer.borderWidth = 1
            }
        }
    }
}


//extension UINavigationController {
//
//    func applyTheme(theme: ThemeProtocol) {
//        if #available(iOS 13.0, *) {
//            print("SET COLORS")
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithTransparentBackground()
//            appearance.backgroundColor = UIColor.systemRed
//            appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText] // With a red background, make the title more readable.
//            navigationBar.standardAppearance = appearance
//            navigationBar.scrollEdgeAppearance = appearance
//            navigationBar.compactAppearance = appearance // F
//
//        }
//       // UIApplication.shared.setStatusBarColor(UIColor.yellow)
//    }
//}

//extension UIApplication {
//
//    @available(iOS, introduced: 9.0, deprecated: 13.0)
//    private var statusBarView: UIView? {
//        if responds(to: Selector(("statusBar"))) {
//            return value(forKey: "statusBar") as? UIView
//        }
//        return nil
//    }
//
//    func setStatusBarColor(_ color: UIColor?) {
//        if #available(iOS 13.0, *) {
//            addStatusBarView(withBG: color)
//        } else {
//            statusBarView?.backgroundColor = color
//        }
//    }
//
//    @available(iOS 13.0, *)
//    private func addStatusBarView(withBG color: UIColor?) {
//        guard let statusBar = keyWindow?.subviews.compactMap({ $0 as? DPStatusBarView }).first else {
//            let statusBar = DPStatusBarView(backgroundColor: color)
//            keyWindow?.addSubview(statusBar)
//            return
//        }
//
//        statusBar.backgroundColor = color
//    }
//
//    // Call this method from baseController's viewWillTransistion
//    // to avoid UI glitches in the status bar area when user changes orientation
//    @available(iOS 13.0, *)
//    func removeStatusBarView() {
//        if let statusBar = keyWindow?.subviews.compactMap({ $0 as? DPStatusBarView }).first {
//            statusBar.removeFromSuperview()
//        }
//    }
//}



//func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
//    if #available(iOS 13.0, *) {
//        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.configureWithOpaqueBackground()
//        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
//        navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
//        navBarAppearance.backgroundColor = backgoundColor
//
//        navigationController?.navigationBar.standardAppearance = navBarAppearance
//        navigationController?.navigationBar.compactAppearance = navBarAppearance
//        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
//
//        navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.tintColor = tintColor
//        navigationItem.title = title
//
//    } else {
//        // Fallback on earlier versions
//        navigationController?.navigationBar.barTintColor = backgoundColor
//        navigationController?.navigationBar.tintColor = tintColor
//        navigationController?.navigationBar.isTranslucent = false
//        navigationItem.title = title
//    }
//}}
