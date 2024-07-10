import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchEarthquakeData(completion: @escaping (Result<[Earthquake], Error>) -> Void) {
        let urlString = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let earthquakeData = try decoder.decode(EarthquakeData.self, from: data)
                
                // Extract earthquakes from features
                let earthquakes = try earthquakeData.features.map { feature -> Earthquake in
                    let properties = feature.properties
                    let coordinates = feature.geometry.coordinates
                    
                    // Ensure coordinates array has at least 2 elements
                    guard coordinates.count >= 2 else {
                        throw NSError(domain: "Invalid coordinates format", code: 0, userInfo: nil)
                    }
                    
                    // Create Earthquake instance with coordinates
                    let quakeCoordinates = Earthquake.Coordinates(latitude: coordinates[1], longitude: coordinates[0])
                    return Earthquake(magnitude: properties.magnitude,
                                      place: properties.place,
                                      time: properties.time,
                                      coordinates: quakeCoordinates)
                }
                
                completion(.success(earthquakes))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
