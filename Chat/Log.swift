//
//  Log.swift
//  Chat
//
//  Created by Anton Bebnev on 23.09.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation


class Log {
    static func debug(_ object: Any, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        #if IS_LOGS_ENABLED
            let fileURL = NSURL(string: file)?.lastPathComponent ?? ""
            print("\(fileURL) > \(function)[\(line)]: \(object)\n")
        #endif
    }
}
