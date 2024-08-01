//
//  MatchDetailViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 31.07.2024.
//

import UIKit
import CoreLocation

final class MatchDetailViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblTempDesc: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    //MARK: - Properties
    private let locationManager = CLLocationManager()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
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
