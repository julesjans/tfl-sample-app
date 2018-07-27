//
//  Colours.swift
//  tfl-app
//
//  Created by Julian Jans on 27/07/2018.
//  Copyright © 2018 Julian Jans. All rights reserved.
//

import UIKit


// Colours sourced from: http://content.tfl.gov.uk/tfl-colour-standards-issue04.pdf

extension UIColor {
    
    static func corporateRed() -> UIColor {
        return UIColor(red: 220, green: 36, blue: 31)
    }
    
    static func corporateGreen() -> UIColor {
        return UIColor(red: 0, green: 114, blue: 41)
    }
    
    static func corporateBlue() -> UIColor {
        return UIColor(red: 0, green: 25, blue: 168)
    }
    
    static func corporateYellow() -> UIColor {
        return UIColor(red: 255, green: 206, blue: 0)
    }
    
    static func corporateGrey() -> UIColor {
        return UIColor(red: 5, green: 143, blue: 152)
    }
    
    static func corporateDarkGrey() -> UIColor {
        return UIColor(red: 65, green: 75, blue: 86)
    }
    
    static func corporateBlack() -> UIColor {
        return UIColor.black
    }
    
    static func corporateWhite() -> UIColor {
        return UIColor.white
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

}
