//
//  RequestSenderErrorEnum.swift
//  Chat
//
//  Created by Anton Bebnev on 18.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

enum RequestSenderErrors: Error {
    case canNotParseToUrl
    case error(msg: String)
    case canNotParseData
}
