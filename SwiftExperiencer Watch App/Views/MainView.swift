//
//  ContentView.swift
//  SwiftExperiencer Watch App
//
//  Created by Julia Grill on 27.05.24.
//

import SwiftUI
import CoreLocationUI
import HealthKit
import SwiftData
import WidgetKit

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var healthStore: HKHealthStore
    
    @Query(sort: \MoodEntry.timestamp, order: .reverse) var moodEntries: [MoodEntry]

    @StateObject var locationManager = LocationManager()

    @State private var isMoodEntryActive = false
    @State private var selectedMoodScale: MoodScale = .unwell
    @State private var errorHappened = false

    var swiftHealthStore = SwiftHealthKit.healthKit

    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    locationManager.requestLocation()
                    isMoodEntryActive = true
                } label: {
                    Text("ADD ENTRY")
                        .font(.subheadline)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .frame(maxHeight: .infinity, alignment: .centerFirstTextBaseline)
                Group {
                    if !moodEntries.isEmpty {
                        Text("Last Entry: \(String(describing: moodEntries.first!.timestamp!.getFormattedDate(format: "HH:mm:ss dd-MM-yy")))")
                            .font(.footnote)
                    } else {
                        Text("No entries yet")
                            .font(.footnote)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .navigationTitle {
                Text("Experiencer")
                    .foregroundStyle(.orange)
            }
        }
        .onChange(of: selectedMoodScale) {
            saveMoodEntry(moodScale: selectedMoodScale)
        }
        .sheet(isPresented: $isMoodEntryActive) {
            MoodEntryView(selectedMoodScale: $selectedMoodScale)
        }
        .onAppear {
            locationManager.requestAuthorization()
        }
    }
    
    // HEALTH STORAGE
    
    private func locationHealthCallback(locations: [CLLocation]) -> Void {
        let lastTimestamp = locations.first?.timestamp
        if locations.count <= 1 {
            readHeartRate(currentTimestamp: lastTimestamp ?? Date(), timeDifference: TimeDifference(hours: 1))
            return
        }
        let secondLastTimestamp = locations[1].timestamp

        readHeartRate(currentTimestamp: lastTimestamp ?? Date(), previousTimestamp: secondLastTimestamp)
    }
    
    private func saveMoodEntry(moodScale: MoodScale) -> Void {
        if moodEntries.isEmpty {
            readHeartRate(currentTimestamp: Date(), timeDifference: TimeDifference(hours: 1))
        } else {
            readHeartRate(currentTimestamp: Date(), previousTimestamp: moodEntries[0].timestamp)
        }
    }
    
    private func readHeartRate(currentTimestamp: Date, previousTimestamp: Date? = nil, timeDifference: TimeDifference? = nil) -> Void {
        let quantityType  = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let sampleQuery = HKSampleQuery.init(sampleType: quantityType,
                                             predicate: getXTimePredicate(timeDifference: timeDifference, previousTimestamp: previousTimestamp, currentTimestamp: currentTimestamp),
                                             limit: HKObjectQueryNoLimit,
                                             sortDescriptors: [sortDescriptor],
                                             resultsHandler: { (query, results, error) in
            
            guard let samples = results as? [HKQuantitySample] else {
                print(error!)
                return
            }

            var heartRateMetaData: [HeartRateMetaData] = []
            
            for sample in samples {
                let metaData = HeartRateMetaData(heartRate: sample.quantity.doubleValue(for: HKUnit(from: "count/min")), timestamp: sample.startDate)
                heartRateMetaData.append(metaData)
            }
            
            // handle case where previous entry was long in the past
            
            let moodEntry = MoodEntry(scale: selectedMoodScale.rawValue, timestamp: Date(), heartRateMetaData: heartRateMetaData, longitude: locationManager.location?.longitude, latitude: locationManager.location?.latitude)
            if let longitude = locationManager.location?.longitude, let latitude = locationManager.location?.latitude {
                CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemark, error in
                    guard let placemark = placemark, error == nil else {
                        saveMoodEntry(moodEntry: moodEntry)
                        return
                    }
                    moodEntry.address = placemark[0].formatAddress()
                    saveMoodEntry(moodEntry: moodEntry)
                }
            } else {
                saveMoodEntry(moodEntry: moodEntry)
            }
        })
        self.swiftHealthStore.execute(sampleQuery)
    }
    
    private func saveMoodEntry(moodEntry: MoodEntry) {
        modelContext.insert(moodEntry)
        do {
            try modelContext.save()
            print("[MainView] Added new mood entry")
        } catch {
            errorHappened = true
        }
    }
    
    private func getXTimePredicate(timeDifference: TimeDifference? = nil, previousTimestamp: Date? = nil, currentTimestamp: Date = Date()) -> NSPredicate {
        if let timeDifference = timeDifference {
            let startDate = Calendar.current.date(byAdding: .hour, value: -timeDifference.hours, to: currentTimestamp)
            return HKQuery.predicateForSamples(withStart: startDate, end: currentTimestamp, options: [])
        }
        let predicate = HKQuery.predicateForSamples(withStart: previousTimestamp, end: currentTimestamp, options: [])
        return predicate
    }
}

#Preview {
    MainView()
        .environmentObject(HKHealthStore())
        .modelContainer(DataController.previewContainer)
}
