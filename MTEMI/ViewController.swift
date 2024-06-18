



import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var earthquakes: [Earthquake] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize and set up the table view
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // Register the cell class
        view.addSubview(tableView)
        self.tableView = tableView // Assign to the IBOutlet if you want to use it later

        fetchData()
    }

    // Implement required methods from UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Remove any existing subviews to avoid duplication
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Configure the cell
        let earthquake = earthquakes[indexPath.row]
        let cellLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 20))
        cellLabel.text = "Magnitude: \(earthquake.magnitude)"
        cell.contentView.addSubview(cellLabel)
        
        // Add more labels or views as needed for cell content
        
        return cell
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
                print("Failed to fetch data:", error)
            }
        }
    } 
}
