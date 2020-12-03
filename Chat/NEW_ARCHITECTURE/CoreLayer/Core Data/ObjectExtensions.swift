//
//  ObjectExtensions.swift
//  Chat
//
//  Created by Anton Bebnev on 29.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation
import CoreData

extension Channel_db {
    convenience init(identifier: String, name: String, lastActivity: Date?, lastMessage: String?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.lastActivity = lastActivity
        self.lastMessage = lastMessage
    }
    
    var logString: String {
        var description = "Канал: \(String(describing: name))"
        var dateDescription: String
        if let date = lastActivity {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM HH:mm"
            
            dateDescription = dateFormatter.string(from: date)
        } else {
            dateDescription = ""
        }
        
        if dateDescription != "" {
            description += ", Последняя активность: \(dateDescription)"
        }
        
        return description
    }
    
    public var messagesArray: [Message_db] {
        let set = messages as? Set<Message_db> ?? []
        return set.sorted { (messageDb1, messageDb2) -> Bool in
            guard let created1 = messageDb1.created, let created2 = messageDb2.created else {
                return false
            }
            
            return created2.compare(created1) == .orderedDescending
        }
    }
    
    func makeChannel() -> Channel? {
        guard let identifier = self.identifier, let name = self.name else {
            return nil
        }
        return Channel(identifier: identifier, name: name, lastMessage: lastMessage, lastActivity: lastActivity)
    }
    
}

extension Message_db {
    convenience init(identifier: String, content: String, created: Date, senderId: String, senderName: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.content = content
        self.created = created
        self.senderName = senderName
        self.senderId = senderId
    }
    
    func makeMessage() -> Message? {
        guard let identifier = identifier, let content = self.content, let created = self.created, let senderName = senderName, let senderId = senderId else {
            return nil
        }
        return Message(identifier: identifier, content: content, created: created, senderId: senderId, senderName: senderName)
    }
}
