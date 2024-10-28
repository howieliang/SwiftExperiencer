//
//  MoodEntry.swift
//  SwiftExperiencer
//
//  Created by Julia Grill on 14.06.24.
//

import Foundation
import SwiftData

@Model
class MoodEntry: Codable {
    enum CodingKeys: CodingKey {
        case scale
        case timestamp
        case heartRateMetaData
        case longitude
        case latitude
        case address
    }
    
    var scale: Int?
    var timestamp: Date?
    @Relationship(deleteRule: .nullify, inverse: \HeartRateMetaData.moodEntry) var heartRateMetaData: [HeartRateMetaData]?
    var longitude: Double?
    var latitude: Double?
    var address: String?
    
    init(scale: Int? = nil, timestamp: Date? = nil, heartRateMetaData: [HeartRateMetaData]? = nil, longitude: Double? = nil, latitude: Double? = nil, address: String? = nil) {
        self.scale = scale
        self.timestamp = timestamp
        self.heartRateMetaData = heartRateMetaData
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        scale = try container.decode(Int.self, forKey: .scale)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        heartRateMetaData = try container.decode([HeartRateMetaData].self, forKey: .heartRateMetaData)
        longitude = try container.decode(Double.self, forKey: .longitude)
        latitude = try container.decode(Double.self, forKey: .latitude)
        address = try container.decode(String.self, forKey: .address)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(scale, forKey: .scale)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(heartRateMetaData, forKey: .heartRateMetaData)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(address, forKey: .address)

    }
}
