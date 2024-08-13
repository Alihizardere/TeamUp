//
//  MatchDetailViewModel.swift
//  TeamUp
//
//  Created by alihizardere on 9.08.2024.
//

import Foundation

// MARK: - MatchDEtailViewModelDelegate
enum SportType: String {
    case football = "football"
    case volleyball = "volleyball"
    
    var imageName: String {
        switch self {
        case .football:
            return "footballField"
        case .volleyball:
            return "volleyballCourt"
        }
    }
}

protocol MatchDetailViewModelDelegate: AnyObject {
    func configurePlayerData(players: [Player])
    func setupUI()
    func configureWeatherResponse(weatherResponse: WeatherResponse)
}

protocol MatchDetailViewModelProtocol {
    var delegate: MatchDetailViewModelDelegate? { get set }
    var city: String? { get }
    var district: String? { get }
    var eventArea: String? { get }
    var hour: String? { get }
    var matchDate: String? { get }
    var firstTeamName: String? { get }
    var secondTeamName: String? { get }
    var formattedHostIban: String? { get }
    var hostName: String? { get }
    var matchPrice: String? { get }
    var sportType: SportType? { get }
    var matchShareInfo: String { get }
    func viewDidLoad()
    func loadPlayers()
    func getWeather(for city: String)
    func calculatePricePerPlayer() -> String?
}

// MARK: - MatchDetailViewModel

final class MatchDetailViewModel: MatchDetailViewModelProtocol {
    weak var delegate: MatchDetailViewModelDelegate?
    private var firebaseService: FirebaseServiceProtocol
    private var players = [Player]()
    
    init(firebaseService: FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }
    
    var city: String? {
        return UserDefaults.standard.string(forKey: "city")
    }
    
    var district: String? {
        return UserDefaults.standard.string(forKey: "district")
    }
    
    var eventArea: String? {
        return UserDefaults.standard.string(forKey: "eventArea")
    }
    
    var hour: String? {
        return UserDefaults.standard.string(forKey: "hour")
    }
    
    var matchDate: String? {
        return UserDefaults.standard.string(forKey: "matchDate")
    }
    var firstTeamName: String? {
        return UserDefaults.standard.string(forKey: "firstTeamName")
    }
    
    var secondTeamName: String? {
        return UserDefaults.standard.string(forKey: "secondTeamName")
    }
    
    var formattedHostIban: String? {
        if let iban = UserDefaults.standard.string(forKey: "hostIban") {
            return "TR\(iban)"
        }
        return nil
    }
    
    var hostName: String? {
        return UserDefaults.standard.string(forKey: "hostName")
    }
    
    var matchPrice: String? {
        return UserDefaults.standard.string(forKey: "matchPrice")
    }
    
    var gameType: String? {
        return UserDefaults.standard.string(forKey: "gameType")
    }
    
    var sportType: SportType? {
        if let sportTypeString = UserDefaults.standard.string(forKey: Constants.SportType.key) {
            return SportType(rawValue: sportTypeString)
        }
        return nil
    }
    
    var matchShareInfo: String {
        return """
        Match Date: \(matchDate ?? "N/A")
        Match Hour: \(hour ?? "N/A")
        Location: \(city ?? "N/A")
        District: \(district ?? "N/A")
        Area: \(eventArea ?? "N/A")
        """
    }
    
    func calculatePricePerPlayer() -> String? {
        guard let matchPriceString = matchPrice,
              let matchPrice = Double(matchPriceString),
              let gameTypeString = gameType,
              let numberOfPlayers = extractNumberOfPlayers(from: gameTypeString) else {
            return nil
        }
        
        let pricePerPlayer = matchPrice / Double(numberOfPlayers)
        return String(format: "%.2f", pricePerPlayer)
    }
    
    private func extractNumberOfPlayers(from gameType: String) -> Int? {
        let components = gameType.split(separator: "x").compactMap { Int($0) }
        if components.count == 2 {
            return components.reduce(0, +)
        }
        return nil
    }
    
    func viewDidLoad() {
        delegate?.setupUI()
        loadPlayers()
    }
    
    func loadPlayers() {
        guard let sportType = sportType else { return }
        firebaseService.fetchPlayers(sportType: sportType.rawValue) { [weak self] players in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.players = players
                self.delegate?.configurePlayerData(players: players)
            }
        }
    }
    
    func getWeather(for city: String) {
        ServiceLogic.shared.fetchWeather(city: city) { [weak self] result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    self?.delegate?.configureWeatherResponse(weatherResponse: weatherResponse)
                }
            case .failure(let error):
                print("Failed to fetch weather data: \(error)")
                // Consider adding error handling here
            }
        }
    }
}
