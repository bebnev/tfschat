//
//  ProfileViewController.swift
//  Chat
//
//  Created by Anton Bebnev on 21.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

struct UserProfile {
    let name: String
    let about: String
    var logo: UIImage?
}

class ProfileViewController: ViewController {
    
    // MARK: -Outlets
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var saveProfileButton: UIButton!
    @IBOutlet weak var editLogoButton: UIButton!
    
    // MARK: -Data
    
    var user = UserProfile(name: "Marina Dudarenko", about: "UX/UI designer, web-designer Moscow, Russia", logo: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        fillUserData(user)
    }
    
    private func configureSubviews() {
        saveProfileButton.layer.cornerRadius = 14
        
    }
    
    private func fillUserData(_ user: UserProfile) {
        nameLabel.text = user.name
        aboutLabel.text = user.about
        aboutLabel.setLetterSpacing(-0.33)
        aboutLabel.setLineHeight(1.15)
        
        if user.logo == nil {
            drawLogoPlaceholder(for: user.name)
        }
    }
    
    private func drawLogoPlaceholder(for name: String) {
        let placeholder = UIView(frame: CGRect(x: 0, y: 0, width: logoView.frame.width, height: logoView.frame.height))
        placeholder.backgroundColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1)
        placeholder.layer.masksToBounds = true
        placeholder.layer.cornerRadius = placeholder.bounds.width / 2
        
        logoView.addSubview(placeholder)
        
        let placeholderNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        placeholderNameLabel.text = "MD"
        placeholderNameLabel.textColor = UIColor(red: 0.212, green: 0.216, blue: 0.22, alpha: 1)
        placeholderNameLabel.font = UIFont(name: "Roboto-Regular", size: 120)
        placeholderNameLabel.textAlignment = .center
        placeholderNameLabel.backgroundColor = .clear
        placeholderNameLabel.numberOfLines = 1
        placeholderNameLabel.sizeToFit()
        placeholderNameLabel.center = placeholder.center
        
        placeholder.addSubview(placeholderNameLabel)
    }

}
