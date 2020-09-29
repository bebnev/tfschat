//
//  ConversationTableViewCell.swift
//  Chat
//
//  Created by Anton Bebnev on 29.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell, ConfigurableView {
    
    typealias ConfigurationModel = ConversationCellModel
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupCell()
    }
    
    private func setupCell() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
    }
    
    func configure(with model: ConversationCellModel) {
        nameLabel.text = model.name
        if model.message == "" {
            dateLabel.text = ""
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont.italicSystemFont(ofSize: messageLabel.font.pointSize)
        } else {
            let dateFormatterCell = DateFormatter()
            if Calendar.current.isDateInToday(model.date) {
                dateFormatterCell.dateFormat = "HH:mm"
            } else {
                dateFormatterCell.dateFormat = "dd MMM"
            }
            dateLabel.text = dateFormatterCell.string(from: model.date)
            
            messageLabel.text = model.message
            
            if model.hasUnreadMessages {
                messageLabel.font = UIFont.boldSystemFont(ofSize: messageLabel.font.pointSize)
            } else {
                messageLabel.font = UIFont.systemFont(ofSize: messageLabel.font.pointSize)
            }
        }
        
        avatarImageView.image = model.avatar
        
        if model.isOnline {
            backgroundColor = UIColor(red: 1.00, green: 0.86, blue: 0.55, alpha: 1.00)
            accessoryType = .disclosureIndicator
        } else {
            backgroundColor = UIColor.white
            accessoryType = .none
        }
        
    }
}
