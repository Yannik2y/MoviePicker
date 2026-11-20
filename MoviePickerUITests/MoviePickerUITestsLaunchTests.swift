//
//  MoviePickerUITestsLaunchTests.swift
//  MoviePickerUITests
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import XCTest

final class MoviePickerUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-UITesting", "-SkipOnboarding"]
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
