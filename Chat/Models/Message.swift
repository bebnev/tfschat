//
//  Message.swift
//  Chat
//
//  Created by Anton Bebnev on 21.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    
    func asDictionary() -> [String: Any] {
        let data = ["content": content, "senderId": senderId, "senderName": senderName, "created": Timestamp(date: created)] as [String : Any]
        
        return data
    }
}
