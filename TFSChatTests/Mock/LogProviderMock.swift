//
//  LogProviderMock.swift
//  TFSChatTests
//
//  Created by Anton Bebnev on 03.12.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

@testable import TFSChat
import Foundation

final class LogProviderMock: ILogProvider {
    var callLogCount = 0
    var logData: [[String: Any]] = []
    func log(_ type: LogType, _ object: Any, file: String, function: String, line: Int) {
        callLogCount += 1
        logData.append(["type": type, "msg": object])
    }
}
