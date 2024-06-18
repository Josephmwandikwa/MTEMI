//
//  Earthquake.swift
//  MTEMI
//
//  Created by Martha on 14/06/2024.
//

import Foundation
struct Earthquake: Codable {
    let magnitude: Double
    let place: String
    let time: Double
    
    enum CodingKeys: String, CodingKey {
        case magnitude = "mag"
        case place
        case time
    }
    
    struct Feature: Codable {
        let properties: Earthquake
    }
    
    struct EarthquakeData: Codable {
        let features: [Feature]
    }
}
