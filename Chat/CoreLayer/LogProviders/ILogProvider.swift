//
//  ILogProvider.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

public enum LogType: String {
    case debug = "DEBUG"
}

public protocol ILogProvider {
    func log(_ type: LogType, _ object: Any, file: String, function: String, line: Int)
}
