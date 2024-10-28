//
//  MoodEntryView.swift
//  SwiftExperiencer Watch App
//
//  Created by Julia Grill on 14.06.24.
//

import SwiftUI

struct MoodEntryView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var selectedMoodScale: MoodScale
    
    var body: some View {
        VStack {
            Text("How are you feeling?")
            List {
                ForEach(MoodScale.allCases, id: \.self) { moodScale in
                    MoodButton(moodScale: moodScale, selected: $selectedMoodScale)
                }
            }
        }
        .onChange(of: selectedMoodScale) {
            dismiss()
        }
        .navigationTitle {
            Text("Mood Selection")
                .foregroundStyle(.orange)
        }
    }
}

struct MoodButton: View {
    let moodScale: MoodScale
    
    @Binding var selected: MoodScale
    
    var body: some View {
        Button {
            selected = moodScale
        } label: {
            Text(moodScale.moodToEmoji())
        }
    }
}
