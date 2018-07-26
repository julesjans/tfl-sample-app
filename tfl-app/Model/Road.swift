//
//  Road.swift
//  tfl-app
//
//  Created by Julian Jans on 26/07/2018.
//  Copyright © 2018 Julian Jans. All rights reserved.
//

import Foundation
import CoreLocation

class Road {
    
    var id: String
    var displayName: String
    var statusSeverity: String
    var statusSeverityDescription: String
    var bounds: (nw: CLLocationCoordinate2D, se: CLLocationCoordinate2D)?
    
    required init?(dict: [String: Any]) {
        
        guard [dict["id"], dict["displayName"], dict["statusSeverity"], dict["statusSeverityDescription"], dict["bounds"]] is [String] else {
            assertionFailure()
            return nil
        }
        
        id = dict["id"] as! String
        displayName = dict["displayName"] as! String
        statusSeverity = dict["statusSeverity"] as! String
        statusSeverityDescription = dict["statusSeverityDescription"] as! String
        
        // Extract coordinates from the bounds string
        let coordsArray = (dict["bounds"] as! String).filter({!["[", "]"].contains($0)}).components(separatedBy: ",").map({Double($0)})
        
        if coordsArray is [Double], coordsArray.count == 4  {
            // Coordinates from the API are in the format [Lng, Lat] and [[West, South], [East, North]] so transposing them to NE, SW
            let nw = CLLocationCoordinate2D(latitude: coordsArray[3]!, longitude: coordsArray[0]!)
            let se = CLLocationCoordinate2D(latitude: coordsArray[1]!, longitude: coordsArray[2]!)
            bounds = (nw, se)
        } else {
            assertionFailure()
        }

    }
    
}
