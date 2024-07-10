import UIKit
import MapKit

class MapViewController: UIViewController {
    var place: String?
    var latitude: Double?
    var longitude: Double?
    
    private let mapView : MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.frame = view.bounds
        
        // Initially set to show the world map
        let worldRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360))
        mapView.setRegion(worldRegion, animated: false)
        
        configureMap()
    }
    
    private func configureMap() {
        guard let latitude = latitude, let longitude = longitude else { return }
        
        // Set up the earthquake location
        let earthquakeCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = earthquakeCoordinate
        annotation.title = place
        
        mapView.addAnnotation(annotation)
        
        // Set the region to zoom into the earthquake location
        let zoomRegion = MKCoordinateRegion(center: earthquakeCoordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
        mapView.setRegion(zoomRegion, animated: true)
    }
}
