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
        seeExpectedLayout()
        givenValidRoadIsInput()
        displayRoadName()
        displayStatusSeverity()
        displayStatusSeverityDescription()
    }
    
    func testInputInvalidRoadAndSeeErrorMessage() {
        givenAppOpens()
        seeExpectedLayout()
        givenInvalidRoadIsInput()
        displayInformativeError()
    }
    
}

extension UITests {
    
    func givenAppOpens() {
        continueAfterFailure = false
        XCUIApplication().launch()
        XCUIDevice.shared.orientation = .portrait
    }
    
    func seeExpectedLayout() {
        XCTFail()
    }
    
    func givenValidRoadIsInput() {
        XCTFail()
    }
    
    func givenInvalidRoadIsInput() {
        XCTFail()
    }
    
    func displayRoadName() {
        XCTFail()
    }
    
    func displayStatusSeverity() {
        XCTFail()
    }
    
    func displayStatusSeverityDescription() {
        XCTFail()
    }
    
    func displayInformativeError() {
        XCTFail()
    }
    
}
