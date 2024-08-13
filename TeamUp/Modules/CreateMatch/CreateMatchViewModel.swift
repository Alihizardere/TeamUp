//
//  CreateMatchViewModel.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 7.08.2024.
//

import Foundation

//MARK: - CreateMatchViewModelDelegate

protocol CreateMatchViewModelDelegate: AnyObject {
    func didUpdateCreateButtonState(isEnabled: Bool)
}

//MARK: - CreateMatchViewModelProtocol

protocol CreateMatchViewModelProtocol {
    var delegate: CreateMatchViewModelDelegate? { get set }
    var cities: [Int : String] { get set }
    var districts: [String] { get set }
    var location: String? { get set }
    var hour: String? { get set }
    var matchDate: Date? { get set }
    var hostIban: String? { get set }
    var gameType: String? { get set }
    var hostName: String? { get set }
//    var firstTeamName: String? {get set}
//    var secondTeamName: String? {get set}
//    var totalPrice: String? {get set}
    var createButtonIsEnabled: Bool { get }
    func validateFields() -> Bool
    func load()
    func fetchDistricts(for: Int)
    func setField(field: CreateMatchViewModel.field, value: String?)
}

//MARK: - CreateMatchViewModel

final class CreateMatchViewModel: CreateMatchViewModelProtocol {
    weak var delegate: CreateMatchViewModelDelegate?
    var cities = [Int : String]()
    var districts = [String]()
    
    var location: String? {
        didSet { notifyDelegateIfNeeded() }
    }
    var district: String? {
        didSet { notifyDelegateIfNeeded() }
    }
    var hour: String? {
        didSet { notifyDelegateIfNeeded() }
    }
    var matchDate: Date? {
        didSet { notifyDelegateIfNeeded() }
    }
    var hostIban: String? {
        didSet { notifyDelegateIfNeeded() }
    }
    var gameType: String? {
        didSet { notifyDelegateIfNeeded() }
    }
    var hostName: String? {
        didSet { notifyDelegateIfNeeded() }
    }
//    var firstTeamName: String? {
//        didSet { notifyDelegateIfNeeded() }
//    }
//    var secondTeamName: String? {
//        didSet { notifyDelegateIfNeeded() }
//    }
//    var totalPrice: String? {
//        didSet { notifyDelegateIfNeeded() }
//    }
//    
    var createButtonIsEnabled: Bool {
        return validateFields()
    }
    
    enum field {
        case city, district, hour, matchDate, hostIban, gameType, hostName /*totalPrice, team1, team2*/
    }
    
    func setField(field: field, value: String?) {
        switch field {
        case .city:
            location = value
        case .district:
            district = value
        case .hour:
            hour = value
        case .matchDate:
            if let dateString = value {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                matchDate = dateFormatter.date(from: dateString)
            } else {
                matchDate = nil
            }
        case .hostIban:
            hostIban = value
        case .gameType:
            if let gameTypeString = value, gameTypeString.contains("x") {
                gameType = gameTypeString.split(separator: "x").first.map { String($0) }
            } else {
                gameType = value
            }
        case .hostName:
            hostName = value
//        case .totalPrice:
//            totalPrice = value
//        case .team1:
//            firstTeamName = value
//        case .team2:
//            secondTeamName = value
        }
    }
    
    func validateFields() -> Bool {
        return [
            location?.isEmpty == false,
            hour?.isEmpty == false,
            matchDate != nil,
            hostIban?.isEmpty == false,
            gameType?.isEmpty == false,
            hostName?.isEmpty == false,
//            totalPrice?.isEmpty == false,
//            firstTeamName?.isEmpty == false,
//            secondTeamName?.isEmpty == false
        ].allSatisfy { $0 }
    }
    
    private func notifyDelegateIfNeeded() {
        let isEnabled = createButtonIsEnabled
        delegate?.didUpdateCreateButtonState(isEnabled: isEnabled)
    }
    
    func load() {
        ServiceLogic.shared.fetchCities { result in
            switch result {
            case .success(let cityResponse):
                cityResponse.data?.forEach { item in
                    if let id = item.id, let cityName = item.name {
                        self.cities[id] = cityName
                    }
                }
            case .failure(let error):
                print("Error fetching cities: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchDistricts(for cityID: Int) {
        ServiceLogic.shared.fetchDistricts(id: cityID) { result in
            switch result {
            case .success(let districtResponse):
                if let districtsData = districtResponse.data?.districts {
                    self.districts = districtsData.compactMap { $0.name }
                }
            case .failure(let error):
                print("Error fetching districts: \(error.localizedDescription)")
            }
        }
    }
}
