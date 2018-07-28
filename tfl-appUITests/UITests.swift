//
//  UITests.swift
//  tfl-appUITests
//
//  Created by Julian Jans on 26/07/2018.
//  Copyright © 2018 Julian Jans. All rights reserved.
//

import XCTest

class UITests: XCTestCase {
    
    func testInputValidRoadAndSeeDetails() {
        givenAppOpens()
        XCUIDevice.shared.orientation = .portrait
        seeExpectedLayout()
        XCUIDevice.shared.orientation = .landscapeLeft
        seeExpectedLayout()
        XCUIDevice.shared.orientation = .portrait
        givenInput("a2")
        shouldDisplay(label: "Road Label", value: "A2")
        shouldDisplay(label: "Road Status Content", value: "Good")
        shouldDisplay(label: "Road Status Description Content", value: "No Exceptional Delays")
    }
    
    func testInputInvalidRoadAndSeeErrorMessage() {
        givenAppOpens()
        seeExpectedLayout()
        givenInput("A233")
        shouldDisplayInformativeError(message: "The following road id is not recognised: A233")
        shouldDisplay(label: "Road Label", value: "TFL Coding Challenge")
        shouldDisplay(label: "Road Status Content", value: "No road selected")
        shouldDisplay(label: "Road Status Description Content", value: "No road selected")
    }
    
}

extension UITests {
    
    func givenAppOpens() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments.append("APIClientMock")
        app.launch()
        XCUIDevice.shared.orientation = .portrait
    }
    
    func seeExpectedLayout() {
        let app = XCUIApplication()
        XCTAssertTrue(app.staticTexts["Road Label"].isHittable)
        XCTAssertTrue(app.staticTexts["Road Status Label"].isHittable)
        XCTAssertTrue(app.staticTexts["Road Status Content"].isHittable)
        XCTAssertTrue(app.staticTexts["Road Status Description"].isHittable)
        XCTAssertTrue(app.staticTexts["Road Status Description Content"].isHittable)
        XCTAssertTrue(app.textFields["Search Input"].isHittable)
    }
    
    func givenInput(_ input: String) {
        let app = XCUIApplication()
        app.textFields["Search Input"].tap()
        app.textFields["Search Input"].typeText(input)
        app.buttons["Go"].tap()
    }
    
    func shouldDisplay(label: String, value: String) {
        let app = XCUIApplication()
        let label = app.staticTexts[label]
        let updated = NSPredicate(format: "label == %@", value)
        expectation(for: updated, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func shouldDisplayInformativeError(message: String) {
        let app = XCUIApplication()
        XCTAssertTrue(app.alerts["Sorry"].isHittable)
        XCTAssertTrue(app.alerts["Sorry"].staticTexts[message].isHittable)
        app.alerts["Sorry"].buttons["OK"].tap()
    }
    
}
