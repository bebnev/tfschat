//
//  ConversationCellModel.swift
//  Chat
//
//  Created by Anton Bebnev on 29.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import UIKit

struct ConversationCellModel {
    let name: String
    let message: String
    let date: Date
    let isOnline: Bool
    let hasUnreadMessages: Bool
    let avatar: UIImage
}

// MARK:- JSON

extension ConversationCellModel {
    static func parse(json: [String: Any]) -> ConversationCellModel? {
        guard let name = json["name"] as? String,
            let message = json["message"] as? String,
            let isOnline = json["isOnline"] as? Bool,
            let hasUnreadMessages = json["hasUnreadMessages"] as? Bool,
            let dateString = json["date"] as? String,
            let imageString = json["avatar"] as? String
        else {
            return nil
        }
        let random = Bool.random()
        var date = Date()
        if !random {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if let d = dateFormatter.date(from: dateString) {
                date = d
            }
        }
        
        
        guard let avatar = UIImage(named: imageString) else {
            return nil
        }
        
        return ConversationCellModel(name: name, message: message, date: date, isOnline: isOnline, hasUnreadMessages: hasUnreadMessages, avatar: avatar)
    }
}


