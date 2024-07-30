//
//  PlayerListViewController.swift
//  TeamUp
//
//  Created by alihizardere on 29.07.2024.
//

import UIKit

final class PlayerListViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

  }

  // MARK: - Actions
  @IBAction func addPlayerButtonTapped(_ sender: Any) {
    let playerDetailVC = PlayerDetailViewController(nibName: "PlayerDetailViewController", bundle: nil)
    navigationController?.pushViewController(playerDetailVC, animated: true)
  }
}
