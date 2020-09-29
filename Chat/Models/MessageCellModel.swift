//
//  MessageCellModel.swift
//  Chat
//
//  Created by Anton Bebnev on 29.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

enum MessageType: Int {
    case incoming = 1
    case outgoing = 2
}

struct MessageCellModel {
    let text: String
    let type: MessageType
}
