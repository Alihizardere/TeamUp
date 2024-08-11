//
//  MatchDetailViewModel.swift
//  TeamUp
//
//  Created by alihizardere on 9.08.2024.
//

import Foundation
import CoreLocation

// MARK: - MatchDEtailViewModelDelegate

protocol MatchDetailViewModelDelegate: AnyObject {
    func configurePlayerData(players: [Player])
    func setupUI()
    func configureWeatherResponse(weatherResponse: WeatherResponse)
}

protocol MatchDetailViewModelProtocol {
    var delegate: MatchDetailViewModelDelegate? { get set }
    func viewDidLoad()
    func loadPlayers()
    func getWeather(city: String)

}

// MARK: - MatchDetailViewModel

final class MatchDetailViewModel {
    weak var delegate: MatchDetailViewModelDelegate?
    fileprivate var firebaseService: FirebaseServiceProtocol = FirebaseService()
    private var players = [Player]()

    private func fetchPlayers() {
        guard let sportType = UserDefaults.standard.string(forKey: Constants.SportType.key) else { return }
        firebaseService.fetchPlayers(sportType: sportType) { [weak self] players in
            guard let self else { return }
            DispatchQueue.main.async {
                self.players = players
                self.delegate?.configurePlayerData(players:  players)
            }
        }
    }

    private func fetchWeather(city: String) {
        ServiceLogic.shared.fetchWeather(city: city) { [weak self] result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    self?.delegate?.configureWeatherResponse(weatherResponse: weatherResponse)
                }
            case .failure(let error):
                print("Failed to fetch weather data: \(error)")
            }
        }
    }
}

extension MatchDetailViewModel: MatchDetailViewModelProtocol {

    func viewDidLoad() {
        self.delegate?.setupUI()
    }
    
    func loadPlayers() {
        fetchPlayers()
    }

    func getWeather(city: String) {
        fetchWeather(city: city)
    }
}
