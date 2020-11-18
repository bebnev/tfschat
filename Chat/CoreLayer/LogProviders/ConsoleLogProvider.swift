//
//  ConsoleLogProvider.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

class ConsoleLogProvider: ILogProvider {
    func log(_ type: LogType, _ object: Any, file: String, function: String, line: Int) {
        #if IS_LOGS_ENABLED
            let fileURL = NSURL(string: file)?.lastPathComponent ?? ""
        print("[\(type.rawValue)] : \(fileURL) > \(function)[\(line)]: \(object)\n")
        #endif
    }
}
