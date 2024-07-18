import UIKit
import RxSwift
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    var tableView: UITableView!
    var earthquakes: [Earthquake] = []
    var filteredEarthquakes: [Earthquake] = []
    let disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSearchController()
        fetchData()
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none  // Remove default separator line
        view.addSubview(tableView)
    }

    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredEarthquakes.count : earthquakes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Remove all subviews from the cell's content view
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let earthquake = isFiltering() ? filteredEarthquakes[indexPath.row] : earthquakes[indexPath.row]

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        containerView.isUserInteractionEnabled = true
        containerView.backgroundColor = UIColor.systemGray5

        let magnitudeLabel = UILabel()
        magnitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        magnitudeLabel.text = "Magnitude: \(earthquake.magnitude)"
        magnitudeLabel.isUserInteractionEnabled = true
        magnitudeLabel.tag = indexPath.row

        let placeLabel = UILabel()
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.isUserInteractionEnabled = true
        placeLabel.text = "Place: \(earthquake.place)"

        containerView.addSubview(magnitudeLabel)
        containerView.addSubview(placeLabel)
        cell.contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10),

            magnitudeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            magnitudeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            magnitudeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),

            placeLabel.topAnchor.constraint(equalTo: magnitudeLabel.bottomAnchor, constant: 5),
            placeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            placeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            placeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEarthquake = isFiltering() ? filteredEarthquakes[indexPath.row] : earthquakes[indexPath.row]
        showMap(for: selectedEarthquake)
    }

    @objc func magnitudeLabelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view else { return }
        let index = label.tag
        let earthquake = isFiltering() ? filteredEarthquakes[index] : earthquakes[index]
        showMap(for: earthquake)
    }

    func showMap(for earthquake: Earthquake) {
        let mapVC = MapViewController()
        mapVC.earthquake = earthquake
        navigationController?.pushViewController(mapVC, animated: true)
    }

    func fetchData() {
        NetworkManager.shared.fetchEarthquakes()
            .subscribe(onNext: { [weak self] earthquakes in
                self?.earthquakes = earthquakes
                self?.filteredEarthquakes = earthquakes
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }, onError: { error in
                print("Failed to fetch earthquake data:", error)
                // Handle error presentation if needed
            })
            .disposed(by: disposeBag)
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredEarthquakes = earthquakes.filter { (earthquake: Earthquake) -> Bool in
            return earthquake.place.lowercased().contains(searchText.lowercased())
        }

        tableView.reloadData()
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}
