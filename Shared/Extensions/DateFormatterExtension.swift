//
//  DateFormatterExtension.swift
//  SwiftExperiencer Watch App
//
//  Created by Julia Grill on 26.07.24.
//

import Foundation

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
