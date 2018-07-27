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
    
    var rawSuccessData: [[String: Any]]!
    //    var rawFailureData: [String: Any]!
    
    override func setUp() {
        super.setUp()
        
        let bundle = Bundle(for: type(of: self))
        
        let successURL = bundle.url(forResource: "Success", withExtension: "json")!
        let successData = try! Data(contentsOf: successURL)
        let successJSON = try! JSONSerialization.jsonObject(with: successData, options: .allowFragments)
        rawSuccessData = successJSON as! [[String: Any]]
    
        //        let failureURL = bundle.url(forResource: "Failure", withExtension: "json")!
        //        let failureData = try! Data(contentsOf: failureURL)
        //        let failureJSON = try! JSONSerialization.jsonObject(with: failureData, options: .allowFragments)
        //        rawFailureData = failureJSON as! [String: Any]
    }
    
    func testRoadFromRawJSON() {
        
        let road = Road(dict: rawSuccessData.first!)
        
        XCTAssert(road!.id == "a2")
        XCTAssert(road!.displayName == "A2")
        XCTAssert(road!.statusSeverity == "Good")
        XCTAssert(road!.statusSeverityDescription == "No Exceptional Delays")
        XCTAssert(road!.bounds!.nw.latitude == CLLocationCoordinate2D(latitude:51.49438, longitude: -0.0857).latitude)
        XCTAssert(road!.bounds!.nw.longitude == CLLocationCoordinate2D(latitude:51.49438, longitude: -0.0857).longitude)
        XCTAssert(road!.bounds!.se.latitude == CLLocationCoordinate2D(latitude: 51.44091, longitude: 0.17118).latitude)
        XCTAssert(road!.bounds!.se.longitude == CLLocationCoordinate2D(latitude: 51.44091, longitude: 0.17118).longitude)
        
    }
    
}
