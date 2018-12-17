//
//  Genesis_VisionUITests.swift
//  Genesis VisionUITests
//
//  Created by George on 25/06/2018.
//  Copyright © 2018 Genesis Vision. All rights reserved.
//

import XCTest

class Genesis_VisionUITests: XCTestCase {

    var app: XCUIApplication!
    
    // MARK: - XCTestCase
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        setupSnapshot(app)
        app.launchEnvironment = ["UITest" : "1"]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    // MARK: - Tests
    
    func testSignIn() {
        //ProgramList Unauthorized screen
        snapshot("ProgramList", timeWaitingForIdle: 1.0)
        
        //Sign In screen
        guard app.buttons["Sign In".uppercased()].exists else { return }
        
        app.buttons["Sign In".uppercased()].tap()
        XCTAssert(app.textFields.element(boundBy: 0).exists)
        app.textFields.element(boundBy: 0).tap()
        app.textFields.element(boundBy: 0).children(matching: .button).element.tap()
        app.textFields.element(boundBy: 0).tap()
        app.textFields.element(boundBy: 0).typeText("george@genesis.vision")
        XCTAssert(app.secureTextFields.element(boundBy: 0).exists)
        app.secureTextFields.element(boundBy: 0).tap()
        app.secureTextFields.element(boundBy: 0).children(matching: .button).element.tap()
        app.secureTextFields.element(boundBy: 0).tap()
        app.secureTextFields.element(boundBy: 0).typeText("qwerty")
        XCTAssert(app.buttons["Sign In".uppercased()].exists)
        app.buttons["Sign In".uppercased()].tap()
    }
    
    func testScreenshots2() {
        //Dashoboard screen
        snapshot("Dashboard", timeWaitingForIdle: 1.0)

        //Wallet Authorized screen
        app.tabBars.buttons.element(boundBy: 2).tap()
        snapshot("Wallet", timeWaitingForIdle: 1.0)

        //ProgramList Authorized screen
        app.tabBars.buttons.element(boundBy: 1).tap()

        //Program screen
        //TODO: 
        if app.tables.cells.element(boundBy: 0).exists {
            let cell: XCUIElement = app.tables.cells.element(boundBy: 0)
            if cell.exists {
                cell.tap()
            }
            
            snapshot("Programm", timeWaitingForIdle: 1.0)
        }

        //Invest screen
        XCTAssert(app.staticTexts["Welcome"].exists)
        app.buttons["Invest".uppercased()].tap()
        XCTAssert(app.staticTexts["Welcome"].exists)
        XCTAssert(app.staticTexts["Welcome"].exists)
        app.otherElements["AvailableToInvestValueLabel"].tap()
        snapshot("Invest", timeWaitingForIdle: 1.0)
        app.navigationBars.buttons.element(boundBy: 0).tap()

        //Trades screen
        app.buttons.element(boundBy: 0).tap()
        if app.buttons["Trades".uppercased()].exists {
            app.buttons["Trades".uppercased()].tap()
            snapshot("Trades", timeWaitingForIdle: 1.0)
        }
    }
}
