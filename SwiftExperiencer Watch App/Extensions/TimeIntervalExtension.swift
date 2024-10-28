//
//  TimeIntervalExtension.swift
//  SwiftExperiencer Watch App
//
//  Created by Julia Grill on 09.06.24.
//

import Foundation

struct TimeDifference {
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
}

extension TimeInterval {
    func intervalToHMS() -> TimeDifference {
        let hours = (Int(self) / 3600)
        let minutes = Int(self / 60) - Int(hours * 60)
        let seconds = Int(self) - (Int(self / 60) * 60)
        return TimeDifference(hours: hours, minutes: minutes, seconds: seconds)
    }
}
