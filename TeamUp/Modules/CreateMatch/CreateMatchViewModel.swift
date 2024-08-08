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
    var location: String? { get set }
    var hour: String? { get set }
    var matchDate: Date? { get set }
    var hostIban: String? { get set }
    var gameType: String? { get set }
    var hostName: String? { get set }
    var createButtonIsEnabled: Bool { get }
    func validateFields() -> Bool
    var delegate: CreateMatchViewModelDelegate? { get set }
    func setField(field: CreateMatchViewModel.field, value: String?)
}

//MARK: - CreateMatchViewModel
final class CreateMatchViewModel: CreateMatchViewModelProtocol {
        weak var delegate: CreateMatchViewModelDelegate?
        var location: String? {
            didSet { notifyDelegate() }
        }
        var hour: String? {
            didSet { notifyDelegate() }
        }
        var matchDate: Date? {
            didSet { notifyDelegate() }
        }
        var hostIban: String? {
            didSet { notifyDelegate() }
        }
        var gameType: String? {
            didSet { notifyDelegate() }
        }
        var hostName: String? {
            didSet { notifyDelegate() }
        }
        
        var createButtonIsEnabled: Bool {
            return validateFields()
        }
        
        enum field {
            case location, hour, matchDate, hostIban, gameType, hostName
        }
        
        func setField(field: field, value: String?) {
            switch field {
            case .location:
                location = value
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
            }
        }
        
        func validateFields() -> Bool {
            let locationValid = !(location?.isEmpty ?? true)
            let hourValid = !(hour?.isEmpty ?? true)
            let matchDateValid = matchDate != nil
            let hostIbanValid = !(hostIban?.isEmpty ?? true)
            let gameTypeValid = !(gameType?.isEmpty ?? true)
            let hostNameValid = !(hostName?.isEmpty ?? true)
            return locationValid && hourValid && matchDateValid && hostIbanValid && gameTypeValid && hostNameValid
        }
        
        private func notifyDelegate() {
            delegate?.didUpdateCreateButtonState(isEnabled: createButtonIsEnabled)
        }
    }

