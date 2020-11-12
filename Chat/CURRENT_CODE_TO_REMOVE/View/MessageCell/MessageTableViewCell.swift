//
//  MessageTableViewCell.swift
//  Chat
//
//  Created by Anton Bebnev on 21.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell, ConfigurableView {

    typealias ConfigurationModel = Message
    
    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var cellContentWrapperView: UIView!
    @IBOutlet weak var cellContentStackView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("awakeFromNib")
        setupView()
    }
    
    private func setupView() {
        cellContentWrapperView.layer.cornerRadius = 8
    }
    
    func configure(with model: Message) {
        nameLabel.text = model.senderName
        messageLabel.text = model.content
        cellContentWrapperView.backgroundColor = .clear
        if model.senderId != Sender.shared.userId {
            //cellContentWrapperView.backgroundColor = ThemeManager.shared.theme?.incomingCellBackgroundColor
            messageLabel.textColor = ThemeManager.shared.theme?.mainTextColor
            nameLabel.textColor = ThemeManager.shared.theme?.mainTextColor
            nameLabel.isHidden = false
            nameLabel.text = model.senderName
            cellContentStackView.alignment = .leading
        } else {
            //cellContentWrapperView.backgroundColor = ThemeManager.shared.theme?.outgoingCellBackgroundColor
            messageLabel.textColor = ThemeManager.shared.theme?.outgoingMessagesTextColor
            nameLabel.isHidden = true
            nameLabel.text = ""
            cellContentStackView.alignment = .trailing
        }

        backgroundColor = ThemeManager.shared.theme?.mainBackgroundColor
    }
    
}
