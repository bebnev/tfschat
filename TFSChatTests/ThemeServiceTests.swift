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
        themeService = ThemeService(themeStorage: cacheStorageMock, dispatchQueue: MockDispatchQueue())
    }

    override func tearDown() {
        cacheStorageMock = nil
        themeService = nil
        super.tearDown()
    }

    func testSaveTheme() throws {
        //let expectation = XCTestExpectation(description: "Completion was called")
        themeService.save(ClassicTheme()) {}
        
        XCTAssertEqual(self.cacheStorageMock.callSaveCount, 1)
    }
    
//    func testNotExistentTheme() throws {
//        let expectation = XCTestExpectation(description: "Completion")
//        expectation.isInverted = true
//        themeService.save(UnknownThemeMock()) {
//            expectation.fulfill()
//        }
//        
//        XCTAssertEqual(cacheStorageMock.callSaveCount, 0)
//        wait(for: [expectation], timeout: 1)
//    }
    
    func testFetchTheme() throws {
        themeService.save(ClassicTheme()) {
        }
        let theme = themeService.fetchTheme()
        XCTAssertEqual(cacheStorageMock.callFetchCount, 1)
        XCTAssertNotNil(theme)
        XCTAssertTrue(theme is ClassicTheme)
    }
    
    func testFetchWithRemovedTheme() throws {
        themeService.save(ClassicTheme()) {
        }
        cacheStorageMock.savedData.removeAll()
        
        let theme = themeService.fetchTheme()
        XCTAssertEqual(cacheStorageMock.callFetchCount, 1)
        XCTAssertNil(theme)
    }
    
    func testFetchUnknownTheme() throws {
        themeService.save(ClassicTheme()) {
        }
        _ = cacheStorageMock.save(key: themeService.key, data: 999)
        
        let theme = themeService.fetchTheme()
        XCTAssertEqual(cacheStorageMock.callFetchCount, 1)
        XCTAssertNil(theme)
    }

}
