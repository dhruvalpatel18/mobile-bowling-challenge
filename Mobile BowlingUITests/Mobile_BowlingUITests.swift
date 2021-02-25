//
//  Mobile_BowlingUITests.swift
//  Mobile BowlingUITests
//
//  Created by Dhruval Patel on 12/24/20.
//

import XCTest

class Mobile_BowlingUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

        func testSampleBaseUI() throws {
        let app = XCUIApplication()
        app.launch()
        
        let resetButton = app.buttons["resetButton"]
        let bowlButton = app.buttons["bowlButton"]
        let inputLabel1 = app.staticTexts["inputLabel1"]
        
        bowlButton.tap()
        XCTAssertNotEqual("", inputLabel1.label, "inputLabel1 not updated")
        
        XCTAssertFalse(resetButton.isHittable, "Reset Button is not hidden")
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
