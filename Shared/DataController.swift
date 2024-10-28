//
//  DataController.swift
//  SwiftExperiencer
//
//  Created by Julia Grill on 17.06.24.
//

import Foundation
import SwiftData

@MainActor
class DataController {
    static let previewContainer: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: MoodEntry.self, HeartRateMetaData.self, configurations: config)
        let startDate = Calendar.current.date(byAdding: .day, value: -3, to: Date())

        for _ in 0...9 {
            let moodEntry = generateMoodEntry(startDate: startDate!)
            container.mainContext.insert(moodEntry)
        }
        return container
    }()
    
    static func generateMoodEntry(startDate: Date) -> MoodEntry {
        let scale = Int.random(in: 1..<5)
        let timestamp = Date.random(in: Range(uncheckedBounds: (lower: startDate, upper: Date())))
        let heartRateTimestamp = Calendar.current.date(byAdding: .hour, value: -2, to: timestamp)
        var heartRateMetaData: [HeartRateMetaData] = []
        
        for _ in 0...Int.random(in: 2...10) {
            let heartRateTimestamp = Date.random(in: Range(uncheckedBounds: (lower: heartRateTimestamp!, upper: timestamp)))
            heartRateMetaData.append(HeartRateMetaData(heartRate: Double.random(in: 50...120), timestamp: heartRateTimestamp))
        }
        return MoodEntry(scale: scale, timestamp: timestamp, heartRateMetaData: heartRateMetaData, longitude: 51.44706, latitude: 5.486496, address: "Favoritenstrasse 8, 1040, Vienna, Austria") // fix these coordinates
    }
}
