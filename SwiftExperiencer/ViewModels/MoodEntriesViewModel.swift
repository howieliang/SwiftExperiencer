//
//  MoodEntriesViewModel.swift
//  SwiftExperiencer
//
//  Created by Julia Grill on 23.07.24.
//

import SwiftUI

class MoodEntriesViewModel: ObservableObject {
    @Published var filter: DayPartFilter = .all
    @Published var visualizationType: VisualizationType = .mood
    @Published var selectedDay = Date()
}
