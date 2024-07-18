import Foundation

struct Earthquake {
    let magnitude: Double
    let place: String
    let time: Double
    let coordinates: (latitude: Double, longitude: Double)
}
    
   
    struct EarthquakeData: Decodable{
        let features: [features]
    }

struct features: Decodable {
    let properties: properties
    let geometry: geometry
    
}
struct properties: Decodable{
    
    let mag:Double
    let place:String
    let time: Int
    
}

struct geometry: Decodable {
    let coordinates: [ Double]
}
    
    
//    enum CodingKeys: String, CodingKey {
//        case magnitude = "mag"
//        case place
//        case time
////        case coordinates = "geometry"
//    }
//    
//    struct Coordinates: Codable {
//        let latitude: Double
//        let longitude: Double
//    }
//}
//
//struct EarthquakeData: Codable {
//    let features: [Feature]
//    
//    struct Feature: Codable {
//        let properties: Earthquake
//        let geometry: Geometry
//        
//        struct Geometry: Codable {
//            let coordinates: [Double]
//        }
//    }
//}
