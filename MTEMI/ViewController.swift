import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var earthquakes: [Earthquake] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        fetchData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let earthquake = earthquakes[indexPath.row]
        
        let magnitudeLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 20))
        magnitudeLabel.text = "Magnitude: \(earthquake.magnitude)"
        magnitudeLabel.isUserInteractionEnabled = true
        magnitudeLabel.tag = indexPath.row
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(magnitudeLabelTapped(_:)))
        magnitudeLabel.addGestureRecognizer(tapGesture)
        
        cell.contentView.addSubview(magnitudeLabel)
        
        let placeLabel = UILabel(frame: CGRect(x: 10, y: 35, width: view.frame.width - 20, height: 20))
        placeLabel.text = "Place: \(earthquake.place)"
        cell.contentView.addSubview(placeLabel)
        
        return cell
    }

    @objc func magnitudeLabelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        let index = label.tag
        let earthquake = earthquakes[index]
        showMap(for: earthquake)
    }

    func showMap(for earthquake: Earthquake) {
        let mapVC = MapViewController()
        mapVC.place = earthquake.place
        
        let coordinates = getCoordinates(for: earthquake.place)
        mapVC.latitude = coordinates.latitude
        mapVC.longitude = coordinates.longitude
        
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func getCoordinates(for place: String) -> (latitude: Double, longitude: Double) {
        switch place {
        case "San Francisco":
            return (latitude: 37.7749, longitude: -122.4194)
        case "Los Angeles":
            return (latitude: 34.0522, longitude: -118.2437)
        case "Tokyo":
            return (latitude: 35.682839, longitude: 139.759455)
        default:
            return (latitude: 0.0, longitude: 0.0)
        }
    }
    func fetchData() {
            NetworkManager.shared.fetchEarthquakeData { [weak self] result in
                switch result {
                case .success(let earthquakes):
                    self?.earthquakes = earthquakes
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Failed to fetch earthquake data:", error)
                    // Handle error presentation if needed
                }
            }
        }

}
