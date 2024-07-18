import Foundation

import RxSwift



class NetworkManager {

    static let shared = NetworkManager() // Singleton instance



    private let baseURL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"

    private let disposeBag = DisposeBag()



    // Function to fetch earthquake data

    func fetchEarthquakes() -> Observable<[Earthquake]> {

        return Observable.create { observer in

            // Create URLSession

            let session = URLSession.shared

            let url = URL(string: self.baseURL)!

            

            // Create URLSession data task

            let task = session.dataTask(with: url) { data, response, error in

                // Handle response

                if let error = error {

                    observer.onError(error)

                    return

                }

                

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {

                    observer.onError(NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))

                    return

                }

                

                guard let data = data else {

                    observer.onError(NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"]))

                    return

                }

                

                do {

                    let earthquakeData = try JSONDecoder().decode(EarthquakeData.self, from: data)

                    let earthquakes = earthquakeData.features.map { feature -> Earthquake in

                        let properties = feature.properties

                        _ = feature.geometry

                        return Earthquake(magnitude: properties.mag,

                                          place: properties.place,

                                          time: Double(properties.time),

                                          coordinates: (feature.geometry.coordinates[1], feature.geometry.coordinates[0]))

                    }

                    

                    observer.onNext(earthquakes)

                    observer.onCompleted()

                } catch {

                    observer.onError(error)

                }

            }

            

            task.resume()

            

            // Return disposable to cancel request if needed

            return Disposables.create {

                task.cancel()

            }

        }

//        .observeOn(MainScheduler.instance) // Observe on main thread for UI updates

    }

}











