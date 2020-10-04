//
//  ChatMessageTableViewCell.swift
//  Chat
//
//  Created by Anton Bebnev on 29.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ConversationMessageTableViewCell: UITableViewCell, ConfigurableView {
    
    typealias ConfigurationModel = MessageCellModel
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.setLetterSpacing(-0.3)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var chatBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(chatBackgroundView)
        addSubview(messageLabel)
        
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: frame.width * 3 / 4),
            chatBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -5),
            chatBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 5),
            chatBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -8),
            chatBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23)
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        
        if model.type == .incoming {
            chatBackgroundView.backgroundColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
        } else {
            chatBackgroundView.backgroundColor = UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        }
    }
    
}
