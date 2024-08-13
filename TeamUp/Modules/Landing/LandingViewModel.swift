//
//  LandingViewModel.swift
//  TeamUp
//
//  Created by alihizardere on 13.08.2024.
//
// MARK: - LandingViewModelDelegate

protocol LandingViewModelDelegate: AnyObject {
    func setupUI()
    func handleSportSelection(sportType: Constants.SportType)
}

protocol LandingViewModelProtocol {
    var delegate: LandingViewModelDelegate? { get set }
    func viewDidLoad()
    var sports: [String] { get }
    func didSelectSport(at index: Int)
}

// MARK: - LandingViewModel

final class LandingViewModel {
    weak var delegate: LandingViewModelDelegate?
    let sports: [String] = Constants.sports
}

// MARK: - LandingViewModelProtocol

extension LandingViewModel: LandingViewModelProtocol {
    
    func viewDidLoad() {
        delegate?.setupUI()
    }

    func didSelectSport(at index: Int) {
        let selectedSport = sports[index]
        var sportType: Constants.SportType?
        switch selectedSport {
        case "footballIcon":
            sportType = .football
        case "volleyballIcon":
            sportType = .volleyball
        case "basketballIcon":
            sportType = .basketball
        case "tennisIcon":
            sportType = .tennis
        default:
            break
        }
        if let sportType = sportType {
            delegate?.handleSportSelection(sportType: sportType)
        }
    }
}
