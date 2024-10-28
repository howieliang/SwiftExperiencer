//
//  MainView.swift
//  SwiftExperiencer
//
//  Created by Julia Grill on 19.06.24.
//

import Foundation
import SwiftUI

struct MainView: View {
    @Environment(\.modelContext) var modelContext

    var body: some View {
        TabView {
            MoodEntryListView()
                .tabItem { Label("Entries", systemImage: "list.bullet") }
            MoodOverviewView()
                .tabItem { Label("Overview", systemImage: "sum") }
        }
    }
}

#Preview {
    return MainView()
        .modelContainer(DataController.previewContainer)
}
