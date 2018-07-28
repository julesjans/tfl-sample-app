//
//  UnitTests.swift
//  tfl-appTests
//
//  Created by Julian Jans on 26/07/2018.
//  Copyright © 2018 Julian Jans. All rights reserved.
//

import XCTest
import CoreLocation
@testable import tfl_app


class UnitTests: XCTestCase {
    
    func testRoadFromMockAPI() {
        let promise = expectation(description: "testRoadFromMockAPI")
        Road.get(id: nil, api: APIClientMock()) { (roads, error) in
            XCTAssert(roads?.count == 23)
            let road = roads!.first!
            XCTAssert(road.id == "a1")
            XCTAssert(road.displayName == "A1")
            XCTAssert(road.statusSeverity == "Good")
            XCTAssert(road.statusSeverityDescription == "No Exceptional Delays")
            XCTAssert(road.bounds!.nw.latitude == CLLocationCoordinate2D(latitude:51.6562, longitude: -0.25616).latitude)
            XCTAssert(road.bounds!.nw.longitude == CLLocationCoordinate2D(latitude:51.6562, longitude: -0.25616).longitude)
            XCTAssert(road.bounds!.se.latitude == CLLocationCoordinate2D(latitude: 51.5319, longitude: -0.10234).latitude)
            XCTAssert(road.bounds!.se.longitude == CLLocationCoordinate2D(latitude: 51.5319, longitude: -0.10234).longitude)
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRoadFromLiveAPI() {
        let promise = expectation(description: "testRoadFromLiveAPI")
        Road.get(id: nil, api: APIClientLive()) { (roads, error) in
            XCTAssert(roads?.count == 23)
            let road = roads!.first!
            XCTAssert(road.id == "a1")
            XCTAssert(road.displayName == "A1")
            XCTAssert(road.bounds!.nw.latitude == CLLocationCoordinate2D(latitude:51.6562, longitude: -0.25616).latitude)
            XCTAssert(road.bounds!.nw.longitude == CLLocationCoordinate2D(latitude:51.6562, longitude: -0.25616).longitude)
            XCTAssert(road.bounds!.se.latitude == CLLocationCoordinate2D(latitude: 51.5319, longitude: -0.10234).latitude)
            XCTAssert(road.bounds!.se.longitude == CLLocationCoordinate2D(latitude: 51.5319, longitude: -0.10234).longitude)
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
