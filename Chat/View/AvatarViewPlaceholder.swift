//
//  AvatarViewPlaceholder.swift
//  Chat
//
//  Created by Anton Bebnev on 29.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class AvataViewPlaceholder: UIView {
    
    lazy var placeholderNameLabel: UILabel = {
        let placeholder = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        placeholder.textColor = UIColor(red: 0.212, green: 0.216, blue: 0.22, alpha: 1)
        placeholder.font = UIFont(name: "Roboto-Regular", size: self.labelFontSize)
        placeholder.textAlignment = .center
        placeholder.backgroundColor = .clear
        placeholder.numberOfLines = 1
        placeholder.adjustsFontSizeToFitWidth = true
        placeholder.center = self.center
        
        return placeholder
    }()
    
    var userName: String? {
        didSet {
            if let userName = userName {
                placeholderNameLabel.text = String(userName.getAcronyms().prefix(2))
                //placeholderNameLabel.setNeedsLayout()
            }
        }
    }
    
    var labelFontSize: CGFloat = 22 {
        didSet {
            placeholderNameLabel.font = placeholderNameLabel.font.withSize(labelFontSize)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setDefaultBackground()
        layer.cornerRadius = bounds.width / 2
        isUserInteractionEnabled = true
        
        addSubview(placeholderNameLabel)
    }
    
    func clearBackground() {
        backgroundColor = .clear
    }
    
    func setDefaultBackground() {
        backgroundColor = UIColor(red: 0.894, green: 0.908, blue: 0.17, alpha: 1)
    }
}
