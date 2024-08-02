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
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: PlayerCell.identifier, bundle: nil), forCellReuseIdentifier: PlayerCell.identifier)
  }

  override func viewWillAppear(_ animated: Bool) {
    fetchPlayers()
  }

  // MARK: - Private Functions
  private func fetchPlayers(){
    FirebaseService.shared.fetchPlayerKeys { keys in
      self.players.removeAll()
      let group = DispatchGroup()
      for key in keys {
        group.enter()
        FirebaseService.shared.fetchPlayerData(forKey: key) { player in
          if let player = player {
            self.players.append(player)
          }
          group.leave()
        }
      }
      group.notify(queue: .main) {
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
    let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { _, _, _ in
      let player = self.players[indexPath.row]
      UIAlertController.showAlert(
        on: self ,
        title: "Oyuncuyu sil",
        message: "Oyuncuyu silmek istediğine emin misin?",
        primaryButtonTitle: "Evet",
        primaryButtonStyle: .destructive,
        primaryButtonHandler: {
          FirebaseService.shared.deletePlayer(player) { result in
            switch result {
            case .success(let success):
              self.players.remove(at: indexPath.row)
              tableView.deleteRows(at: [indexPath], with: .automatic)
            case .failure(let error):
              UIAlertController.showAlert(
                on: self,
                title: "Silme İşlemi",
                message: "Silme işlemi yapılamadı tekrar deneyiniz."
              )
            }
          }
        },
        secondaryButtonTitle: "Hayır")
    }
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
}
