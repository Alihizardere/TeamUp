//
//  LandingViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 29.07.2024.
//

import UIKit

final class LandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("This is landing page")
    }
    //MARK: - Actions
    @IBAction func footballButtonTapped(_ sender: UIButton) {
    navigateToHome()
    }
    
    @IBAction func volleyballButtonClicked(_ sender: UIButton) {
        navigateToHome()
    }
    
    //MARK: - Functions
    
    private func navigateToHome() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        navigationController?.pushViewController(homeVC, animated: true)
    }
}
