//
//  ConversationTableViewCell.swift
//  Chat
//
//  Created by Anton Bebnev on 29.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell, ConfigurableView {
    
    typealias ConfigurationModel = Channel
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var themeManager: IThemeManager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
    
    func setupCell() {
        accessoryType = .disclosureIndicator
    }
    
    func configure(with model: Channel) {
        nameLabel.text = model.name
        nameLabel.textColor = themeManager?.theme?.mainTextColor
        messageLabel.textColor = themeManager?.theme?.conversationsCellSubtitleColor
        dateLabel.textColor = themeManager?.theme?.conversationsCellSubtitleColor
        backgroundColor = themeManager?.theme?.mainBackgroundColor
        
        if let date = model.lastActivity {
            let dateFormatterCell = DateFormatter()
            if Calendar.current.isDateInToday(date) {
                dateFormatterCell.dateFormat = "HH:mm"
            } else {
                dateFormatterCell.dateFormat = "dd MMM"
            }
            dateLabel.text = dateFormatterCell.string(from: date)
        } else {
            dateLabel.text = ""
        }
        
        if let lastMessage = model.lastMessage, lastMessage != "" {
            messageLabel.text = lastMessage
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont.italicSystemFont(ofSize: messageLabel.font.pointSize)
        }
        
    }
}
