//
//  NetworkManager.swift
//  MTEMI
//
//  Created by Martha on 14/06/2024.
//

import Foundation
class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchEarthquakeData(completion: @escaping (Result<[Earthquake], Error>) -> Void) {
        let urlString = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let earthquakeData = try JSONDecoder().decode(Earthquake.EarthquakeData.self, from: data)
                let earthquakes = earthquakeData.features.map { $0.properties }
                completion(.success(earthquakes))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
        task.resume()
    }
}
