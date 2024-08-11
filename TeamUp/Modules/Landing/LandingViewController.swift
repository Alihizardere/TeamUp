//
//  LandingViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 29.07.2024.
//

import UIKit

final class LandingViewController: BaseViewController {

    // MARK: -  LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        print("This is landing page")
        if !Reachability.isConnectedToNetwork() {
            showAlertNoInternetConnection()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - ACTIONS

    @IBAction func footballButtonTapped(_ sender: UIButton) {
        handleSportSelection(.football)
    }

    @IBAction func volleyballButtonClicked(_ sender: UIButton) {
        handleSportSelection(.volleyball)
    }
    //MARK: -  PRIVATE FUNCTIONS

    private func checkInternetConnection() {
        if !Reachability.isConnectedToNetwork() {
            showAlertNoInternetConnection()
        }
    }

    private func handleSportSelection(_ sportType: Constants.SportType) {
        if Reachability.isConnectedToNetwork() {
            UserDefaults.standard.set(sportType, forKey: Constants.SportType.key)
            let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
            navigationController?.pushViewController(homeVC, animated: true)
        } else {
            showAlertNoInternetConnection()
        }
    }
}
