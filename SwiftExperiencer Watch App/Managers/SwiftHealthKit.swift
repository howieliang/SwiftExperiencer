//
//  SwiftHealthKit.swift
//  SwiftExperiencer Watch App
//
//  Created by Julia Grill on 31.05.24.
//

import Foundation
import HealthKit

class SwiftHealthKit: ObservableObject {
    static let healthKit = HKHealthStore()
}
