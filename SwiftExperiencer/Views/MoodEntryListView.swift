//
//  MoodEntryListView.swift
//  SwiftExperiencer
//
//  Created by Julia Grill on 27.05.24.
//

import SwiftUI
import HealthKit
import SwiftData
import CoreLocation
import MapKit

struct MoodEntryListView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \MoodEntry.timestamp, order: .reverse) var moodEntries: [MoodEntry]
    
    var sortedMoodEntriesByDay: [Date: [MoodEntry]] {
        var days: [Date: [MoodEntry]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        for moodEntry in moodEntries {
            let timestampDay = moodEntry.timestamp!.getFormattedDate(format: "dd-MM-yy")
            if let day = dateFormatter.date(from: timestampDay) {
                var dayEntry = days[day] ?? []
                dayEntry.append(moodEntry)
                days[day] = dayEntry
            }
        }
        return days
    }
    
    var headers: [Date] {
        sortedMoodEntriesByDay.map({ $0.key }).sorted().reversed()
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(headers, id: \.self) { dateHeader in
                    Section(header: Text(dateHeader, style: .date)) {
                        ForEach(sortedMoodEntriesByDay[dateHeader]!) { moodEntry in
                            NavigationLink {
                                MoodDetailView(moodEntry: moodEntry)
                            } label: {
                                HStack {
                                    Text("\(moodEntry.timestamp!.getFormattedDate(format: "HH:mm:ss")): \(String(describing: MoodScale(rawValue: moodEntry.scale!)!.moodToEmoji()))")
                                }
                            }
                        }
                        .onDelete { deleteMoodEntry(at: $0, at: dateHeader) }
                        .listStyle(.insetGrouped)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .padding()
    }
    
    private func deleteMoodEntry(at offsets: IndexSet, at day: Date) {
        for offset in offsets {
            let moodEntry = sortedMoodEntriesByDay[day]![offset]
            modelContext.delete(moodEntry)
        }
        try? modelContext.save()
    }
}

#Preview {
    return MoodEntryListView()
        .modelContainer(DataController.previewContainer)
}
