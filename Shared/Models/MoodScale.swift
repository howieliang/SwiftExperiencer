//
//  MoodScale.swift
//  SwiftExperiencer
//
//  Created by Julia Grill on 14.06.24.
//

import Foundation

enum MoodScale: Int, Codable, CaseIterable {
    case unwell = 1, ok, good, great
    
    func moodToEmoji() -> String {
        switch self {
        case .unwell: return "☹️"
        case .ok: return "😐"
        case .good: return "😊"
        case .great: return "😆"
        }
    }
}
