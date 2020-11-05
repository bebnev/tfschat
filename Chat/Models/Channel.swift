//
//  Channel.swift
//  Chat
//
//  Created by Anton Bebnev on 20.10.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}
