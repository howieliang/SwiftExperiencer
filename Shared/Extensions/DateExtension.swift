//
//  DateExtension.swift
//  SwiftExperiencer Watch App
//
//  Created by Julia Grill on 14.06.24.
//

import Foundation

extension Date {
   func getFormattedDate(format: String = "HH:mm:ss dd-MM-yy") -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    static func random(in range: Range<Date>) -> Date {
        Date(
            timeIntervalSinceNow: .random(
                in: range.lowerBound.timeIntervalSinceNow...range.upperBound.timeIntervalSinceNow
            )
        )
    }
}
