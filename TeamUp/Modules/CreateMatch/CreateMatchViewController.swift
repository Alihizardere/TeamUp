//
//  CreateMatchViewController.swift
//  TeamUp
//
//  Created by alihizardere on 29.07.2024.
//

import UIKit
import CoreLocation

final class CreateMatchViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTemprature: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var tempImage: UIImageView!
    
    var players = [Player]()
    private let locationManager = CLLocationManager()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLocationManager()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPlayers()
    }
    
    //MARK: - Private Functions
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PlayerCell.identifier, bundle: nil), forCellReuseIdentifier: PlayerCell.identifier)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func fetchPlayers() {
        FirebaseService.shared.fetchPlayerKeys { keys in
            self.players.removeAll()
            let group = DispatchGroup()
            for key in keys {
                group.enter()
                FirebaseService.shared.fetchPlayerData(forKey: key) { player in
                    if let player = player {
                        self.players.append(player)
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchWeather(for location: CLLocation) {
        WeatherLogic.shared.fetchWeather(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        ) { [weak self] result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    if let temp = weatherResponse.main?.temp {
                        self?.lblTemprature.text = "\(temp)°C"
                    }
                    if let weather = weatherResponse.weather?.first {
                        self?.lblDesc.text = weather.description?.capitalized
                        self?.updateWeatherImage(for: weather)
                        print("Weather description from API: \(weather.description ?? "")")
                    }
                }
            case .failure(let error):
                print("Failed to fetch weather data: \(error)")
            }
        }
    }

    private func updateWeatherImage(for weather: Weather) {
        switch weather.main?.lowercased() {
        case "rain":
            tempImage.image = UIImage(systemName: "cloud.rain")
        case "clear":
            tempImage.image = UIImage(systemName: "sun.min.fill")
            tempImage.tintColor = .systemYellow
        case "clouds":
            tempImage.image = UIImage(systemName: "cloud.fill")
            tempImage.tintColor = .systemGray3
        default:
            tempImage.image = UIImage(systemName: "questionmark.circle")
        }
    }

    
    //MARK: - Button Actions
    @IBAction func createMatchButtonTapped(_ sender: Any) {
        let matchDetailVC = MatchDetailViewController(nibName: "MatchDetailViewController", bundle: nil)
        navigationController?.pushViewController(matchDetailVC, animated: true)
    }
}

//MARK: - Extension TableViewDelegate && TableViewDataSource
extension CreateMatchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.identifier, for: indexPath) as? PlayerCell else { return UITableViewCell() }
        let player = players[indexPath.row]
        cell.configure(with: player)
        return cell
    }
}

//MARK: - ExtensionCLLocationManagerDelegate
extension CreateMatchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks,error) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let placemark = placemarks?.first else {return }
            self.lblLocation.text = [placemark.locality, placemark.administrativeArea].compactMap{ $0 }.joined(separator: ", ")
            self.fetchWeather(for: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
    }
}
