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
  var players = [Player]()

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(
      UINib(nibName: PlayerCell.identifier, bundle: nil),
      forCellReuseIdentifier: PlayerCell.identifier
    )
    observePlayers()
  }

  // MARK: - Private Functions
  private func observePlayers() {
    guard let sportType = UserDefaults.standard.string(forKey: "sportType") else { return }
    FirebaseService.shared.observePlayer(sportType: sportType) { [weak self] players in
      guard let self else { return }
      DispatchQueue.main.async {
        self.players = players
        self.tableView.reloadData()
      }
    }
  }

  // MARK: - Actions
  @IBAction func addPlayerButtonTapped(_ sender: Any) {
    let playerDetailVC = PlayerDetailViewController(nibName: "PlayerDetailViewController", bundle: nil)
    navigationController?.pushViewController(playerDetailVC, animated: true)
  }
}

extension PlayerListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    players.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.identifier, for: indexPath) as? PlayerCell else { return UITableViewCell() }
    let player = players[indexPath.row]
    cell.configure(with: player)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let player = players[indexPath.row]
    let playerDetailVC = PlayerDetailViewController(nibName: "PlayerDetailViewController", bundle: nil)
    playerDetailVC.selectedPlayer = player
    navigationController?.pushViewController(playerDetailVC, animated: true)
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, completionHandler in
      guard let self else { return }
      guard let sportType = UserDefaults.standard.string(forKey: "sportType") else { return }
      let player = players[indexPath.row]

      UIAlertController.showAlert(
        on: self,
        title: "Delete Player",
        message: "Are you sure you want to delete the player?",
        primaryButtonTitle: "OK",
        primaryButtonStyle: .destructive,
        primaryButtonHandler: {
          self.players.remove(at: indexPath.row)
          tableView.deleteRows(at: [indexPath], with: .automatic)
          FirebaseService.shared.deletePlayer(player, sportType: sportType) { result in
            switch result {
            case .success:
              completionHandler(true)
            case .failure:
              UIAlertController.showAlert(
                on: self,
                title: "Delete",
                message: "Deletion failed, try again."
              )
              completionHandler(false)
            }
          }
        },
        secondaryButtonTitle: "Cancel")
    }
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
}
