import UIKit
import MapKit

class MapViewController: UIViewController {
    var place: String?
    var latitude: Double?
    var longitude: Double?
    var magnitude: Double?
    var earthquake: Earthquake?

    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        setupTapGesture()

        if let earthquake = earthquake {
            showEarthquakeLocationOnMap(earthquake)
        } else if let latitude = latitude, let longitude = longitude, let place = place, let magnitude = magnitude {
            showSelectedLocationOnMap(latitude: latitude, longitude: longitude, place: place, magnitude: magnitude)
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
        addAnnotation(
            title: "Magnitude: \(earthquake.magnitude)",
            subtitle: "\(earthquake.place)",
            coordinate: CLLocationCoordinate2D(latitude: earthquake.coordinates.latitude, longitude: earthquake.coordinates.longitude)
        )
    }

    private func showSelectedLocationOnMap(latitude: Double, longitude: Double, place: String, magnitude: Double) {
        addAnnotation(
            title: "Magnitude: \(magnitude)",
            subtitle: "Place: \(place)",
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        )
    }

    private func addAnnotation(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)

        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500000, longitudinalMeters: 500000)
        mapView.setRegion(region, animated: true)
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }

    @objc private func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

//        addAnnotation(
//            title: "Selected Location",
//            subtitle: "Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)",
//            coordinate: coordinate
//        )

        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
        mapView.setRegion(region, animated: true)
    }
}
