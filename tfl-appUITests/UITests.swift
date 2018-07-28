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
        selectWithPicker("Blackwall Tunnel")
        shouldDisplay(label: "Road Status Content", value: "Good")
        shouldDisplay(label: "Road Status Description Content", value: "No Exceptional Delays")
        selectWithPicker("A2")
        shouldDisplay(label: "Road Status Content", value: "Closure")
        shouldDisplay(label: "Road Status Description Content", value: "Closure")
        selectWithPicker("A40")
        shouldDisplay(label: "Road Status Content", value: "Good")
        shouldDisplay(label: "Road Status Description Content", value: "No Exceptional Delays")
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
        XCTAssertTrue(app.pickerWheels.element.isHittable)
        XCTAssertTrue(app.staticTexts["Road Status Label"].isHittable)
        XCTAssertTrue(app.staticTexts["Road Status Content"].isHittable)
        XCTAssertTrue(app.staticTexts["Road Status Description"].isHittable)
        XCTAssertTrue(app.staticTexts["Road Status Description Content"].isHittable)
    }
    
    func selectWithPicker(_ input: String) {
        let app = XCUIApplication()
        app.pickerWheels.element.adjust(toPickerWheelValue: input)
    }
    
    func shouldDisplay(label: String, value: String) {
        let app = XCUIApplication()
        let label = app.staticTexts[label]
        let updated = NSPredicate(format: "label == %@", value)
        expectation(for: updated, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
