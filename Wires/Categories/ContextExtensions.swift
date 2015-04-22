//
//  String+ContextExtensions.swift
//  Wires
//
//  Created by Patrick Perini on 4/21/15.
//  Copyright (c) 2015 pcperini. All rights reserved.
//

import UIKit

extension NSDate {
    // Time of Day Context
    func temporalGreeting() -> String {
        let dateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: self)
        
        switch dateComponents.hour {
        case 5 ..< 12:
            return NSLocalizedString("morning", comment: "")
            
        case 12 ..< 17:
            return NSLocalizedString("afternoon", comment: "")
            
        case 17 ..< 24, 0 ..< 5:
            return NSLocalizedString("evening", comment: "")
            
        default:
            return NSLocalizedString("day", comment: "")
        }
    }
}
