//
//  DayDetailView.swift
//  SwiftExperiencer
//
//  Created by Julia Grill on 23.07.24.
//

import Foundation
import SwiftUI
import SwiftData
import Charts
import MapKit

struct DayDetailView: View {
    let selectedDay: Date
    @ObservedObject var viewModel: MoodEntriesViewModel
    @Query(sort: \MoodEntry.timestamp, order: .reverse) var moodEntries: [MoodEntry]

    var filteredMoodEntries: [MoodEntry] {
        moodEntries.filter { entry in
            if !Calendar.current.isDate(selectedDay, equalTo: entry.timestamp!, toGranularity: .day) {
                return false
            }
            switch viewModel.filter {
            case .all:
                return true
            case .morning:
                return Calendar.current.component(.hour, from: entry.timestamp!) < 12
            case .afternoon:
                let hour = Calendar.current.component(.hour, from: entry.timestamp!)
                return hour >= 12 && hour < 18
            case .evening:
                return Calendar.current.component(.hour, from: entry.timestamp!) >= 18
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Picker("Filter", selection: $viewModel.filter) {
                        ForEach(DayPartFilter.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Spacer()
                }
                if filteredMoodEntries.isEmpty {
                    Text("NO ENTRIES").font(.title)
                    Spacer()
                } else {
                    Text("Average Mood: \(MoodScale(rawValue: averageMood())!.moodToEmoji())")
                        .font(.title3)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    Text("Average Heart Rate: \(averageHeartRate())")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    VStack(spacing: 0) {
                        Text("Locations:")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        List(filteredMoodEntries, id: \.self) { moodEntry in
                            NavigationLink(destination: MoodDetailView(moodEntry: moodEntry)) {
                                HStack {
                                    Text(moodEntry.address!)
                                    Text((moodEntry.timestamp!.getFormattedDate(format: "HH:mm:ss")))
                                }
                            }
                        }
                        .frame(height: 180)
                    }
                    Picker("Visualization", selection: $viewModel.visualizationType) {
                        ForEach(VisualizationType.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    VisualizationView(moodEntries: filteredMoodEntries, viewModel: viewModel)
                }
            }
        }
        .navigationTitle("\(selectedDay, formatter: DateFormatter.shortDate)")
    }

    func averageMood() -> Int {
        let totalMood = filteredMoodEntries.reduce(0) { $0 + $1.scale! }
        return filteredMoodEntries.isEmpty ? 0 : totalMood / filteredMoodEntries.count
    }

    func averageHeartRate() -> Int {
        let filteredEntries = filteredMoodEntries.flatMap { $0.heartRateMetaData! }
        let totalHeartRate = filteredEntries.reduce(0) { $0 + $1.heartRate! }
        return filteredEntries.isEmpty ? 0 : Int(totalHeartRate) / filteredEntries.count
    }
}

struct VisualizationView: View {
    let moodEntries: [MoodEntry]
    @ObservedObject var viewModel: MoodEntriesViewModel

    var body: some View {
        switch viewModel.visualizationType {
        case .mood:
            MoodChartView(moodEntries: moodEntries)
        case .heartRate:
            HeartRateChartView(moodEntries: moodEntries)
        case .map:
            MoodMapView(moodEntries: moodEntries)
        }
    }
}

struct MoodChartView: View {
    let moodEntries: [MoodEntry]

    var body: some View {
        Chart(moodEntries) { entry in
            LineMark(
                x: .value("Time", entry.timestamp!, unit: .minute),
                y: .value("Mood", entry.scale!)
            )
            .symbol(.circle)
            .symbolSize(150)
        }
        .chartYScale(domain: 0...5)
    }
}

struct HeartRateChartView: View {
    let moodEntries: [MoodEntry]

    var body: some View {
        Chart(moodEntries.flatMap { $0.heartRateMetaData! }) { entry in
            PointMark(
                x: .value("Time", entry.timestamp!, unit: .minute),
                y: .value("Heart Rate", entry.heartRate!)
            )
            
        }
    }
}

struct MoodMapView: View {
    let moodEntries: [MoodEntry]

    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: moodEntries[0].latitude!, longitude: moodEntries[0].longitude!),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )), annotationItems: moodEntries) { entry in
            MapPin(coordinate: CLLocationCoordinate2D(latitude: moodEntries[0].latitude!, longitude: moodEntries[0].longitude!))
        }
    }
}

#Preview {
    return DayDetailView(selectedDay: Date(), viewModel: MoodEntriesViewModel())
        .modelContainer(DataController.previewContainer)
}
