//
//  TFSChatUITests.swift
//  TFSChatUITests
//
//  Created by Anton Bebnev on 03.12.2020.
//  Copyright © 2020 Anton Bebnev. All rights reserved.
//

import XCTest

class TFSChatUITests: XCTestCase {

    func testEditableFieldsInProfileViewController() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let avatarView = app.navigationBars.otherElements["ChannelListAvatarView"].firstMatch
        let isAvatarViewExist = avatarView.waitForExistence(timeout: 5)
        
        XCTAssertTrue(isAvatarViewExist)
        avatarView.tap()
        
        let nameTextField = app.textFields["ProfileNameTextField"].firstMatch
        let aboutTextView = app.textViews["ProfileAboutTextView"].firstMatch
        
        let isNameTextFieldExist = nameTextField.waitForExistence(timeout: 5)
        let isAboutTextViewExist = aboutTextView.waitForExistence(timeout: 5)
        
        XCTAssertTrue(isNameTextFieldExist)
        XCTAssertTrue(isAboutTextViewExist)
    }
}
