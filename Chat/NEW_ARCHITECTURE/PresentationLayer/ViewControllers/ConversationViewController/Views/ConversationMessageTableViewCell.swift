//
//  ChatMessageTableViewCell.swift
//  Chat
//
//  Created by Anton Bebnev on 29.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ConversationMessageTableViewCell: UITableViewCell, ConfigurableView {
    
    typealias ConfigurationModel = Message
    
    var themeManager: IThemeManager?
    
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
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let name = UILabel()
    let message = UITextView()
    
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
        addSubview(userNameLabel)
        
        let constraints = [
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            //userNameLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -10),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            userNameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: frame.width * 3 / 4),
            messageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10),
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
    
    func configure(with model: Message) {
        messageLabel.text = model.content
        userNameLabel.textColor = themeManager?.theme?.mainTextColor
        
        if model.senderId != Sender.shared.userId {
            chatBackgroundView.backgroundColor = themeManager?.theme?.incomingCellBackgroundColor
            messageLabel.textColor = themeManager?.theme?.mainTextColor
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
            userNameLabel.text = model.senderName
        } else {
            chatBackgroundView.backgroundColor = themeManager?.theme?.outgoingCellBackgroundColor
            messageLabel.textColor = themeManager?.theme?.outgoingMessagesTextColor
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            userNameLabel.text = ""
        }

        backgroundColor = themeManager?.theme?.mainBackgroundColor
    }
}
