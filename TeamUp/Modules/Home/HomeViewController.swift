//
//  HomeViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 29.07.2024.
//

import UIKit

final class HomeViewController: UIViewController {

  // MARK: - Properties

  // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("This is Home page")
    }

  // MARK: - Actions
    @IBAction func playerListButtonTapped(_ sender: UIButton) {
      let playerListVC = PlayerListViewController(nibName: "PlayerListViewController", bundle: nil)
      navigateToDestinationVC(viewController: playerListVC)
    }

    @IBAction func createMatchButtonTapped(_ sender: UIButton) {
      let createMatchVC = CreateMatchViewController(nibName: "CreateMatchViewController", bundle: nil)
      navigateToDestinationVC(viewController: createMatchVC)
    }

    // MARK: - Functions
    private func navigateToDestinationVC(viewController: UIViewController) {
      navigationController?.pushViewController(viewController, animated: true)
    }
}
