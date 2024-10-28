//
//  MoodEntryView.swift
//  SwiftExperiencer
//
//  Created by Julia Grill on 17.06.24.
//

import Foundation
import SwiftUI
import Charts
import SwiftData

struct MoodDetailView: View {
    @Environment(\.modelContext) var modelContext
    let moodEntry: MoodEntry
    
    var body: some View {
        VStack {
            List {
                Text("Mood: \(String(describing: MoodScale(rawValue: moodEntry.scale!)!.moodToEmoji()))")
                Text("Timestamp: \(String(describing:  moodEntry.timestamp!.getFormattedDate()))")
                if let address = moodEntry.address {
                    Text("Location: \(address)")
                }
                Text("Associated HR data points:").font(.title3).fontWeight(.bold)
                if let heartRateMetaData = moodEntry.heartRateMetaData, !heartRateMetaData.isEmpty {
                    Chart(moodEntry.heartRateMetaData!) {
                        PointMark(x: .value("Time", $0.timestamp!, unit: .minute), y: .value("HR", $0.heartRate!))
                        
                    }
                    .frame(height: 300).frame(width: 300)
                    .chartLegend(.visible)
                    .chartYAxis(.visible)
                } else {
                    Text("No HR data available").font(.title3)
                }
            }
        }
        .navigationTitle("Mood Entry")
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MoodEntry.self, HeartRateMetaData.self, configurations: config)
    let startDate = Calendar.current.date(byAdding: .hour, value: -8, to: Date())
    return MoodDetailView
        .init(moodEntry: DataController.generateMoodEntry(startDate: startDate!))
        .modelContainer(container)
}
