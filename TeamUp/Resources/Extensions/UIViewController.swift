//
//  UIViewController.swift
//  TeamUp
//
//  Created by alihizardere on 11.08.2024.
//

import UIKit

enum DestinationVC: String {
    case onboarding = "OnboardingViewController"
    case landing = "LandingViewController"
    case home = "HomeViewController"
    case playerList = "PlayerListViewController"
    case playerDetail = "PlayerDetailViewController"
    case createMatch = "CreateMatchViewController"
    case matchDetail = "MatchDetailViewController"
    case setPlayers = "SetPlayersViewController"

    var nibName: String {
        return self.rawValue
    }
}

extension UIViewController {
    static func instantiate<T: UIViewController>(from destination: DestinationVC) -> T {
        return T(nibName: destination.nibName, bundle: nil)
    }
}
