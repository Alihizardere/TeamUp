//
//  MatchDetailViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 31.07.2024.
//

import UIKit
import CoreLocation

final class MatchDetailViewController: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblTempDesc: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var lblNumberOfPlayers: UILabel!
    @IBOutlet weak var lblShowAllPlayers: UILabel!
    @IBOutlet weak var lblHostIban: UILabel!
    @IBOutlet weak var lblHostName: UILabel!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var nextMatchView: UIView!
    @IBOutlet weak var hostView: UIView!
    @IBOutlet weak var playersView: UIView!
    
    //MARK: - Properties
    private let locationManager = CLLocationManager()
    private var players = [Player]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        loadUserDefaults()
        observePlayers()
        setupShowAllPlayersTapGesture()
        setupCornerRadius(for: [weatherView, nextMatchView,hostView,playersView], radius: 10)
    }
    
    
    //MARK: - Private Functions
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func fetchWeather(for location: CLLocation) {
        WeatherLogic.shared.fetchWeather(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        ) { [weak self] result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    if let tempInFahrenheit = weatherResponse.main?.temp {
                        let tempInCelsius = tempInFahrenheit - 273.15
                        self?.lblTemp.text = "\(Int(tempInCelsius))°C"
                    }
                    if let wind = weatherResponse.wind {
                        self?.lblWind.text = "\(Int(wind.speed ?? 700)) km/s"
                    }
                    if let weather = weatherResponse.weather?.first {
                        self?.lblTempDesc.text = weather.description?.capitalized
                        self?.updateWeatherImage(for: weather)
                        print("Weather description from API: \(weather.description ?? "")")
                    }
                }
            case .failure(let error):
                print("Failed to fetch weather data: \(error)")
            }
        }
    }
    
    private func observePlayers() {
        guard let sportType = UserDefaults.standard.string(forKey: "sportType") else { return }
        FirebaseService.shared.observePlayer(sportType: sportType) { [weak self] players in
            guard let self else { return }
            DispatchQueue.main.async {
                self.players = players
                self.lblNumberOfPlayers.text = String(players.count)
            }
        }
    }
    
    private func loadUserDefaults() {
        let defaults = UserDefaults.standard
        lblHour.text = defaults.string(forKey: "hour") ?? "N/A"
        lblDate.text = defaults.string(forKey: "matchDate") ?? "N/A"
        lblHostIban.text = (("TR\(defaults.string(forKey: "hostIban") ?? "N/A")"))
        lblHostName.text = defaults.string(forKey: "hostName") ?? "N/A"
    }
    
    private func updateWeatherImage(for weather: Weather) {
        switch weather.main?.lowercased() {
        case "rain":
            weatherImage.image = UIImage(systemName: "cloud.rain")
        case "clear":
            weatherImage.image = UIImage(systemName: "sun.min.fill")
            weatherImage.tintColor = .systemYellow
        case "clouds":
            weatherImage.image = UIImage(systemName: "cloud.fill")
            weatherImage.tintColor = .systemGray3
        default:
            weatherImage.image = UIImage(systemName: "questionmark.circle")
        }
    }
    
    private func setupCornerRadius(for views: [UIView], radius: CGFloat) {
        views.forEach { view in
            view.layer.cornerRadius = radius
            view.layer.masksToBounds = true
        }
    }
    
    private func setupShowAllPlayersTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAllPlayersTapped))
        lblShowAllPlayers.isUserInteractionEnabled = true
        lblShowAllPlayers.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showAllPlayersTapped() {
        let playerListVC = PlayerListViewController(nibName: "SetTeamsViewController", bundle: nil)
        navigationController?.pushViewController(playerListVC, animated: true)
    }
}

//MARK: - Extension TableViewDelegate && TableViewDataSource
extension MatchDetailViewController: CLLocationManagerDelegate {
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
        //TODO: Alert eklenecek
        print("Failed to get user location: \(error)")
    }
}
