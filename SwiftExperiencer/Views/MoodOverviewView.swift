//
//  MoodOverviewView.swift
//  SwiftExperiencer
//
//  Created by Julia Grill on 19.06.24.
//

import Foundation
import SwiftUI
import SwiftData
import Alamofire

struct MoodOverviewView: View {
    @Environment(\.modelContext) var modelContext
    
    @ObservedObject var viewModel = MoodEntriesViewModel()
    
    @State private var showingIpAddress = false
    @State private var showingCompletion = false
    @State private var popupMessage = ""
    @State private var ipAddress = ""
    
    @State var selectedTab: Tabs = .overview

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
    
    var addedMoodEntries: [Date: [MoodEntry]] = [:]
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                MoodDayView()
                    .tabItem {
                        Label("Overview", systemImage: "sum")
                    }
                    .tag(Tabs.overview)
                MoodEntryListView()
                    .tabItem {
                        Label("All Entries", systemImage: "list.bullet")
                    }
                    .tag(Tabs.entries)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Export") {
                        showingIpAddress = true
                    }
                    .alert("Server Address + Port", isPresented: $showingIpAddress) {
                        TextField("Enter server URL", text: $ipAddress)
                                        .textInputAutocapitalization(.never)
                        Button("OK", role: .cancel) { 
                            sendDataToServer()
                        }
                    }
                    .alert(popupMessage, isPresented: $showingCompletion) {
                        Button("OK", role: .cancel) { }
                    }
                }
            }
            .navigationTitle(selectedTab.rawValue.capitalized)
        }
    }
    
    private func sendDataToServer() {
        if let data = try? JSONEncoder().encode(moodEntries) {
            let json = String(data: data, encoding: String.Encoding.utf8)
            let parameters: Parameters = [
                "id": UIDevice.current.identifierForVendor!.uuidString,
                "data": json!
            ]
            AF.request(ipAddress, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: ServerResponse.self) { response in
                switch response.result {
                case .success(let value):
                    popupMessage = value.response
                case .failure(let error):
                    popupMessage = error.localizedDescription
                }
                showingCompletion = true
            }
        }
    }
}

enum Tabs: String{
    case overview = "Day Entries"
    case entries = "All Entries"
}

#Preview {
    return MoodOverviewView()
        .modelContainer(DataController.previewContainer)
}
