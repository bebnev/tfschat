//
//  LogServiceTests.swift
//  TFSChatTests
//
//  Created by Anton Bebnev on 03.12.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//
@testable import TFSChat
import XCTest

class LogServiceTests: XCTestCase {

    var logService: LogServive!
    var logProviderMock: LogProviderMock!
    
    override func setUp() {
        super.setUp()
        logProviderMock = LogProviderMock()
        logService = LogServive(providers: [logProviderMock])
    }

    override func tearDown() {
        logProviderMock = nil
        logService = nil
        super.tearDown()
    }

    func testDebugCall() throws {
        XCTAssertEqual(logProviderMock.callLogCount, 0)
        logService.debug("some string")
        XCTAssertEqual(logProviderMock.callLogCount, 1)
    }
    
    func testDebugMessages() throws {
        let logMessage = "another log string"
        logService.debug(logMessage)
        let loggedData = logProviderMock.logData.first
        
        guard let type = loggedData?["type"] as? LogType, let msg = loggedData?["msg"] as? String else {
            assertionFailure()
            return
        }
        
        XCTAssertEqual(type, LogType.debug)
        XCTAssertEqual(msg, logMessage)
        
    }

}
