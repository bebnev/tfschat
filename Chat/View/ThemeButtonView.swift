//
//  ThemeButton.swift
//  Chat
//
//  Created by Anton Bebnev on 07.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ThemeButtonView: UIView {
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleButtonTouch), for: .touchUpInside)
        return button
    }()
    
    lazy var leftBubble: UIView = {
        let leftView = UIView()
        
        leftView.addSubview(self.leftImage)
        
        return leftView
    }()
    
    lazy var rightBubble: UIView = {
        let rightView = UIView()
        
        rightView.addSubview(self.rightImage)
        
        return rightView
    }()
    
    lazy var leftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var rightImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "Default"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleButtonTouch))
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    lazy var bubblesContainerView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [self.leftBubble, self.rightBubble])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 4
        sv.isUserInteractionEnabled = false
        
        return sv
    }()
    
    var buttonLabelText: String? {
        didSet {
            if let title = buttonLabelText {
                buttonLabel.text = title
            }
        }
    }
    
    var buttonLabelTextColor: UIColor? {
        didSet {
            if let color = buttonLabelTextColor {
                buttonLabel.textColor = color
            }
        }
    }
    
    var leftImageContent: UIImage? {
        didSet {
            if let image = leftImageContent {
                leftImage.image = image
            }
        }
    }
    
    var rightImageContent: UIImage? {
       didSet {
           if let image = rightImageContent {
               rightImage.image = image
           }
       }
    }
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                button.layer.borderWidth = 3
                button.layer.borderColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1).cgColor
            } else {
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1).cgColor
            }
        }
    }
    
    var onHandleTouch: ((_ senderTag: Int) -> Void)?
       
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
        setupLayout()
    }
    
    func setupView() {
        isSelected = false
        addSubview(button)
        
        button.addSubview(bubblesContainerView)
        addSubview(buttonLabel)
    }
    
    func setupLayout() {
        let constraints = [
            heightAnchor.constraint(equalToConstant: 100),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            button.heightAnchor.constraint(equalToConstant: 57),
            bubblesContainerView.topAnchor.constraint(equalTo: button.topAnchor, constant: 14),
            bubblesContainerView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -10),
            bubblesContainerView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 27),
            bubblesContainerView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -27),
            leftImage.topAnchor.constraint(equalTo: leftBubble.topAnchor, constant: 0),
            leftImage.leadingAnchor.constraint(equalTo: leftBubble.leadingAnchor, constant: 0),
            leftImage.trailingAnchor.constraint(equalTo: leftBubble.trailingAnchor, constant: 0),
            rightImage.bottomAnchor.constraint(equalTo: rightBubble.bottomAnchor, constant: 0),
            rightImage.leadingAnchor.constraint(equalTo: rightBubble.leadingAnchor, constant: 0),
            rightImage.trailingAnchor.constraint(equalTo: rightBubble.trailingAnchor, constant: 0),
            buttonLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            buttonLabel.centerXAnchor.constraint(equalTo: centerXAnchor)

        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc
    func handleButtonTouch(_ sender: Any) {
        guard let onHandleTouch = onHandleTouch else {
            return
        }
        
        onHandleTouch(tag)
    }
}
