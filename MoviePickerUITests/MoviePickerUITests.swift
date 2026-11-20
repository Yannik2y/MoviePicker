//
//  MoviePickerUITests.swift
//  MoviePickerUITests
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import XCTest

final class MoviePickerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunchAndOpenMenu() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITesting", "-SkipOnboarding"]
        app.launch()
        
        // Menu button should exist (hamburger)
        let menuButton = app.buttons.firstMatch
        XCTAssertTrue(menuButton.waitForExistence(timeout: 5))
    }

    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                let app = XCUIApplication()
                app.launchArguments = ["-UITesting", "-SkipOnboarding"]
                app.launch()
            }
        }
    }
}
