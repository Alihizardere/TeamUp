//
//  HomeViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 29.07.2024.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        print("This is Home page")
    }

    // MARK: - FUNTIONS

    private func navigateToDestinationVC(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - ACTIONS

    @IBAction func playerListButtonTapped(_ sender: UIButton) {
        let playerListVC: PlayerListViewController = UIViewController.instantiate(from: .playerList )
        navigateToDestinationVC(viewController: playerListVC)
    }

    @IBAction func createMatchButtonTapped(_ sender: UIButton) {
        let createMatchVC: CreateMatchViewController = UIViewController.instantiate(from: .createMatch)
        navigateToDestinationVC(viewController: createMatchVC)
    }
}
