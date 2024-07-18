
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

        let annotation = MKPointAnnotation()

        annotation.title = "Magnitude: \(earthquake.magnitude)"

        annotation.subtitle = "\(earthquake.place)"

        annotation.coordinate = CLLocationCoordinate2D(latitude: earthquake.coordinates.latitude, longitude: earthquake.coordinates.longitude)

        mapView.addAnnotation(annotation)



        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500000, longitudinalMeters: 500000)

        mapView.setRegion(region, animated: true)



        // Select the annotation programmatically

        mapView.selectAnnotation(annotation, animated: true)

    }



    private func showSelectedLocationOnMap(latitude: Double, longitude: Double, place: String, magnitude: Double) {

        let annotation = MKPointAnnotation()

        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        annotation.title = "Magnitude: \(magnitude)"

        annotation.subtitle = "Place: \(place)"

        mapView.addAnnotation(annotation)



        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500000, longitudinalMeters: 500000)

        mapView.setRegion(region, animated: true)



        // Select the annotation programmatically

        mapView.selectAnnotation(annotation, animated: true)

    }



    private func setupTapGesture() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))

        mapView.addGestureRecognizer(tapGesture)

    }



    @objc private func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {

        let location = gestureRecognizer.location(in: mapView)

        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)



        // Remove existing annotations

//        mapView.removeAnnotations(mapView.annotations)



        // Add new annotation

//        let annotation = MKPointAnnotation()
//
//        annotation.coordinate = coordinate
//
//        annotation.title = "Selected Location"
//
//        annotation.subtitle = "Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)"
//
//        mapView.addAnnotation(annotation)



        // Optionally, you can zoom in to the selected location

        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)

        mapView.setRegion(region, animated: true)



        // Select the annotation programmatically

//        mapView.selectAnnotation(annotation, animated: true)

    }

}






