import UIKit
import MapKit


class MapViewController: UIViewController {
    var place: String??
    var latitude: Double??
    var longitude: Double??
    var earthquake: Earthquake??

    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if let earthquake = earthquake {
            showEarthquakeLocationOnMap(earthquake!)
        }
    }

    private func setupUI() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func setupNavigation() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        }

        @objc private func backButtonTapped() {
            navigationController?.popViewController(animated: true)
        }

    private func showEarthquakeLocationOnMap(_ earthquake: Earthquake) {
        let annotation = MKPointAnnotation()
        annotation.title = "\(earthquake.magnitude)"
        annotation.subtitle = earthquake.place
        annotation.coordinate = CLLocationCoordinate2D(latitude: earthquake.coordinates.latitude, longitude: earthquake.coordinates.longitude)
        mapView.addAnnotation(annotation)

        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500000, longitudinalMeters: 500000)
        mapView.setRegion(region, animated: true)
    }
}



























//class MapViewController: UIViewController {
////    var place: String?
////    var latitude: Double?
////    var longitude: Double?
//    
//    var earthquake: Earthquake??
//    
//    private let mapView : MKMapView = {
//        let mapView = MKMapView()
//        mapView.translatesAutoresizingMaskIntoConstraints = false
//        return mapView
//    }()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(mapView)
//        mapView.frame = view.bounds
//        
//        // Initially set to show the world map
//        let worldRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
//        mapView.setRegion(worldRegion, animated: false)
//        
//        configureMap()
//    }
//    
//    private func configureMap() {
//        guard let latitude = earthquake.latitude, let longitude = longitude else { return }
//        
//        // Set up the earthquake location
//        let earthquakeCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = earthquakeCoordinate
//        annotation.title = earthquake.feature.place
//        
//        mapView.addAnnotation(annotation)
//        
//        // Set the region to zoom into the earthquake location
//        let zoomRegion = MKCoordinateRegion(center: earthquakeCoordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
//        mapView.setRegion(zoomRegion, animated: true)
//    }
//}
