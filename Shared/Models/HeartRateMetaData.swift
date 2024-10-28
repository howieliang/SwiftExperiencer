//
//  HeartRateMetaData.swift
//  SwiftExperiencer
//
//  Created by Julia Grill on 14.06.24.
//

import Foundation
import HealthKit
import SwiftData

@Model
class HeartRateMetaData: Codable {
    enum CodingKeys: CodingKey {
        case heartRate
        case timestamp
    }
    
    var heartRate: Double?
    var timestamp: Date?
    var moodEntry: MoodEntry?
    
    init(heartRate: Double? = nil, timestamp: Date? = nil, moodEntry: MoodEntry? = nil) {
        self.heartRate = heartRate
        self.timestamp = timestamp
        self.moodEntry = moodEntry
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        heartRate = try container.decode(Double.self, forKey: .heartRate)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(heartRate, forKey: .heartRate)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
