//
//  WatchWidget.swift
//  WatchWidget
//
//  Created by Julia Grill on 14.06.24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    
    @MainActor var mostRecentMoodEntry: MoodEntry? {
        let container = try! ModelContainer(for: MoodEntry.self, HeartRateMetaData.self)
        let descriptor = FetchDescriptor<MoodEntry>(sortBy: [SortDescriptor(\.timestamp)].reversed())
        let moods = try! container.mainContext.fetch(descriptor)
        return moods.isEmpty ? nil : moods[0]
    }
    
    @MainActor func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), mostRecentDate: mostRecentMoodEntry?.timestamp?.getFormattedDate(format: "HH:mm:ss"))
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        await SimpleEntry(date: Date(), mostRecentDate: mostRecentMoodEntry?.timestamp?.getFormattedDate(format: "HH:mm:ss"))

    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        return await Timeline(entries: [SimpleEntry(date: Date(), mostRecentDate: mostRecentMoodEntry?.timestamp?.getFormattedDate(format: "HH:mm:ss"))], policy: .atEnd)
    }
    
    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "SwiftExperiencer")]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let mostRecentDate: String?
}

struct WatchWidgetEntryView : View {
    @Query(sort: \MoodEntry.timestamp, order: .reverse) var moodEntries: [MoodEntry]
    
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Add SwiftExperience")
                .font(.footnote)
        }
    }
}

@main
struct WatchWidget: Widget {
    @Environment(\.modelContext) var modelContext

    let kind: String = "WatchWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, provider: Provider()) { entry in
            WatchWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

#Preview(as: .accessoryRectangular) {
    WatchWidget()
} timeline: {
    SimpleEntry(date: .now, mostRecentDate: "19-08-24")
}
