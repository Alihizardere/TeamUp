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
  }

  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = true
  }

  //MARK: - ACTIONS

  @IBAction func footballButtonTapped(_ sender: UIButton) {
    UserDefaults.standard.set(Constants.SportType.football, forKey: Constants.SportType.key)
    navigateToHome()
  }

  @IBAction func volleyballButtonClicked(_ sender: UIButton) {
    UserDefaults.standard.set(Constants.SportType.volleyball, forKey: Constants.SportType.key)
    navigateToHome()
  }

  //MARK: -  Private Functions
  private func navigateToHome() {
    let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
    navigationController?.pushViewController(homeVC, animated: true)
  }
}
