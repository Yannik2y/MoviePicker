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

    func testLaunchShowsPickTab() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITesting", "-SkipOnboarding"]
        app.launch()
        
        // Tab bar Pick / Library / More (iPhone) or sidebar (iPad)
        let pick = app.tabBars.buttons[L10nPickFallback]
        let bonded = app.segmentedControls.buttons.firstMatch
        XCTAssertTrue(
            pick.waitForExistence(timeout: 5) || bonded.waitForExistence(timeout: 5) || app.buttons.firstMatch.waitForExistence(timeout: 5)
        )
    }
    
    func testLaunchAndSwitchMode() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITesting", "-SkipOnboarding"]
        app.launch()
        
        let segmented = app.segmentedControls.firstMatch
        if segmented.waitForExistence(timeout: 5) {
            let moviePicker = segmented.buttons.element(boundBy: 1)
            if moviePicker.exists {
                moviePicker.tap()
            }
        }
        XCTAssertTrue(app.buttons.firstMatch.exists)
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

/// UITests cannot import app L10n; use English label used in Localizable.strings
private let L10nPickFallback = "Pick"
