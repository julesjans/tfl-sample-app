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
        Road.get(id: "a2", api: APIClientMock()) { (roads, error) in
            let road = roads!.first!
            XCTAssert(road.id == "a2")
            XCTAssert(road.displayName == "A2")
            XCTAssert(road.statusSeverity == "Good")
            XCTAssert(road.statusSeverityDescription == "No Exceptional Delays")
            XCTAssert(road.bounds!.nw.latitude == CLLocationCoordinate2D(latitude:51.49438, longitude: -0.0857).latitude)
            XCTAssert(road.bounds!.nw.longitude == CLLocationCoordinate2D(latitude:51.49438, longitude: -0.0857).longitude)
            XCTAssert(road.bounds!.se.latitude == CLLocationCoordinate2D(latitude: 51.44091, longitude: 0.17118).latitude)
            XCTAssert(road.bounds!.se.longitude == CLLocationCoordinate2D(latitude: 51.44091, longitude: 0.17118).longitude)
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testInvalidRoadFromMockAPI() {
        let promise = expectation(description: "testRoadFromMockAPI")
        Road.get(id: "A233", api: APIClientMock()) { (roads, error) in
            XCTAssert(roads == nil)
            XCTAssert(error!.statusCode == 404)
            XCTAssert(error!.statusMessage == "The following road id is not recognised: A233")
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testRoadFromLiveAPI() {
        let promise = expectation(description: "testRoadFromLiveAPI")
        Road.get(id: "a2", api: APIClientLive()) { (roads, error) in
            let road = roads!.first!
            XCTAssert(road.id == "a2")
            XCTAssert(road.displayName == "A2")
            XCTAssert(road.bounds!.nw.latitude == CLLocationCoordinate2D(latitude:51.49438, longitude: -0.0857).latitude)
            XCTAssert(road.bounds!.nw.longitude == CLLocationCoordinate2D(latitude:51.49438, longitude: -0.0857).longitude)
            XCTAssert(road.bounds!.se.latitude == CLLocationCoordinate2D(latitude: 51.44091, longitude: 0.17118).latitude)
            XCTAssert(road.bounds!.se.longitude == CLLocationCoordinate2D(latitude: 51.44091, longitude: 0.17118).longitude)
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testInvalidRoadFromLiveAPI() {
        let promise = expectation(description: "testRoadFromLiveAPI")
        Road.get(id: "A233", api: APIClientLive()) { (roads, error) in
            XCTAssert(roads == nil)
            XCTAssert(error!.statusCode == 404)
            XCTAssert(!error!.statusMessage!.isEmpty)
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
