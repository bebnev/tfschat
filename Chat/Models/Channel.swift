//
//  Channel.swift
//  Chat
//
//  Created by Anton Bebnev on 20.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation
import CoreData

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    func asCoreDataObject(in context: NSManagedObjectContext) -> Channel_db {
        return Channel_db(identifier: identifier, name: name, lastActivity: lastActivity, lastMessage: lastMessage, context: context)
    }
}
