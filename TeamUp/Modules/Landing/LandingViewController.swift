//
//  LandingViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 29.07.2024.
//

import UIKit

final class LandingViewController: UIViewController {

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    print("This is landing page")
  }
  //MARK: - Actions
  @IBAction func footballButtonTapped(_ sender: UIButton) {
    UserDefaults.standard.set("football", forKey: "sportType")
    navigateToHome()
  }

  @IBAction func volleyballButtonClicked(_ sender: UIButton) {
    UserDefaults.standard.set("volleyball", forKey: "sportType")
    navigateToHome()
  }

  //MARK: -  Private Functions
  private func navigateToHome() {
    let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
    navigationController?.pushViewController(homeVC, animated: true)
  }
}
