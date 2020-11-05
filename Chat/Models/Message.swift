//
//  Message.swift
//  Chat
//
//  Created by Anton Bebnev on 21.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation
import Firebase
import CoreData

struct Message {
    let identifier: String
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    
    func asDictionary() -> [String: Any] {
        let createdTimestamp = Timestamp(date: created)
        let data: [String: Any] = ["content": content, "senderId": senderId, "senderName": senderName, "created": createdTimestamp]
        
        return data
    }
    
    func asCoreDataObject(in context: NSManagedObjectContext) -> Message_db {
        return Message_db(identifier: identifier, content: content, created: created, senderId: senderId, senderName: senderName, context: context)
    }
}
