import Foundation

struct Earthquake: Codable {
    let magnitude: Double
    let place: String
    let time: Double
    let coordinates: Coordinates
    
    enum CodingKeys: String, CodingKey {
        case magnitude = "mag"
        case place
        case time
        case coordinates
    }
    
    struct Coordinates: Codable {
        let latitude: Double
        let longitude: Double
    }
}

struct EarthquakeData: Codable {
    let features: [Feature]
    
    struct Feature: Codable {
        let properties: Properties
        let geometry: Geometry
        
        struct Properties: Codable {
            let magnitude: Double
            let place: String
            let time: Double
            
            enum CodingKeys: String, CodingKey {
                case magnitude = "mag"
                case place
                case time
            }
        }
        
        struct Geometry: Codable {
            let coordinates: [Double]
        }
    }
}
