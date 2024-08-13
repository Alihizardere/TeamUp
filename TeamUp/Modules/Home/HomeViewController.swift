//
//  HomeViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 29.07.2024.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - OUTLETS

    @IBOutlet weak var gifImageView: UIImageView!

    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        gifImageView.startGifAnimation(name: "fanGif", duration: 6)
    }

    // MARK: - ACTIONS

    @IBAction func playerListButtonTapped(_ sender: UIButton) {
        let playerListVC: PlayerListViewController = UIViewController.instantiate(from: .playerList )
        navigationController?.pushViewController(playerListVC, animated: true)
    }

    @IBAction func createMatchButtonTapped(_ sender: UIButton) {
        let createMatchVC: CreateMatchViewController = UIViewController.instantiate(from: .createMatch)
        navigationController?.pushViewController(createMatchVC, animated: true)
    }
}
