//
//  SwiftExperiencerApp.swift
//  SwiftExperiencer
//
//  Created by Julia Grill on 27.05.24.
//

import SwiftUI
import SwiftData

@main
struct SwiftExperiencerApp: App {
    var body: some Scene {
        WindowGroup {
            MoodOverviewView()
        }
        .modelContainer(for: [MoodEntry.self, HeartRateMetaData.self])
//        .modelContainer(DataController.previewContainer) // for local development as CloudKit is not reliable in the simulator
    }
}
