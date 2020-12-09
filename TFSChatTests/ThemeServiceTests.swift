//
//  ThemeServiceTests.swift
//  TFSChatTests
//
//  Created by Anton Bebnev on 03.12.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//
@testable import TFSChat
import XCTest

class ThemeServiceTests: XCTestCase {
    
    var themeService: ThemeService!
    var cacheStorageMock: CacheStorageMock!
    
    override func setUp() {
        super.setUp()
        cacheStorageMock = CacheStorageMock()
        themeService = ThemeService(themeStorage: cacheStorageMock)
    }

    override func tearDown() {
        cacheStorageMock = nil
        themeService = nil
        super.tearDown()
    }

    func testSaveTheme() throws {
        let expectation = XCTestExpectation(description: "Completion was called")
        themeService.save(ClassicTheme()) {
            expectation.fulfill()
        }
        
        XCTAssertEqual(cacheStorageMock.callSaveCount, 1)
        wait(for: [expectation], timeout: 5)
    }
    
    func testNotExistentTheme() throws {
        let expectation = XCTestExpectation(description: "Completion")
        expectation.isInverted = true
        themeService.save(UnknownThemeMock()) {
            expectation.fulfill()
        }
        
        XCTAssertEqual(cacheStorageMock.callSaveCount, 0)
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchTheme() throws {
        let expectation = XCTestExpectation(description: "Completion")
        themeService.save(ClassicTheme()) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        let theme = themeService.fetchTheme()
        XCTAssertEqual(cacheStorageMock.callFetchCount, 1)
        XCTAssertNotNil(theme)
        XCTAssertTrue(theme is ClassicTheme)
    }
    
    func testFetchWithRemovedTheme() throws {
        let expectation = XCTestExpectation(description: "Completion")
        themeService.save(ClassicTheme()) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        cacheStorageMock.savedData.removeAll()
        
        let theme = themeService.fetchTheme()
        XCTAssertEqual(cacheStorageMock.callFetchCount, 1)
        XCTAssertNil(theme)
    }
    
    func testFetchUnknownTheme() throws {
        let expectation = XCTestExpectation(description: "Completion")
        themeService.save(ClassicTheme()) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        _ = cacheStorageMock.save(key: themeService.key, data: 999)
        
        let theme = themeService.fetchTheme()
        XCTAssertEqual(cacheStorageMock.callFetchCount, 1)
        XCTAssertNil(theme)
    }

}
