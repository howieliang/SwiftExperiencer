//
//  MoodDayView.swift
//  SwiftExperiencer
//
//  Created by Julia Grill on 28.08.24.
//

import Foundation
import SwiftUI
import SwiftData

struct MoodDayView: View {
    @Environment(\.modelContext) var modelContext
    
    @ObservedObject var viewModel = MoodEntriesViewModel()
    
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
    
    var sortedDays: [Date] {
        sortedMoodEntriesByDay.map({ $0.key }).sorted().reversed()
    }
    
    var body: some View {
        List {
            ForEach(sortedDays, id: \.self) { day in
                NavigationLink(destination: DayDetailView(selectedDay: day, viewModel: viewModel)) {
                    Text("\(day, formatter: DateFormatter.shortDate)")
                }
            }
        }
    }
}
