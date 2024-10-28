//
//  SwiftExperiencerApp.swift
//  SwiftExperiencer Watch App
//
//  Created by Julia Grill on 27.05.24.
//

import SwiftUI
import HealthKit
import SwiftData

@main
struct SwiftExperiencer_Watch_AppApp: App {

    private let healthStore: HKHealthStore
    
    private var swiftHealthStore = SwiftHealthKit.healthKit

    init() {
        guard HKHealthStore.isHealthDataAvailable() else {  fatalError("[SwiftExperiencerApp] This app requires a device that supports HealthKit") }
        healthStore = HKHealthStore()
        autorizeHealthKit()
    }
    
    private func autorizeHealthKit() {
        let allTypes: Set<HKSampleType> = Set([
            HKSeriesType.heartbeat(),
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
        ])
        swiftHealthStore.requestAuthorization(toShare: nil, read: allTypes) { (success, error) in
            print("[SwiftExperiencerApp] Request Authorization: Success: ", success, " Error: ", error ?? "nil")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(healthStore)
        }
        .modelContainer(for: [MoodEntry.self, HeartRateMetaData.self])
    }
}

extension HKHealthStore: ObservableObject {}
