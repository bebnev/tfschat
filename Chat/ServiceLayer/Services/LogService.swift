//
//  LogService.swift
//  Chat
//
//  Created by Anton Bebnev on 11.11.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import Foundation

protocol ILogService {
    func debug(_ object: Any, file: String, function: String, line: Int)
}

class LogServive: ILogService {
    let providers: [ILogProvider]
    
    init(providers: [ILogProvider]) {
        self.providers = providers
    }
    
    func debug(_ object: Any, file: String = #file, function: String = #function, line: Int = #line) {
        providers.forEach { (provider) in
            provider.log(.debug, object, file: file, function: function, line: line)
        }
    }
}
