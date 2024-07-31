//
//  CreateMatchViewController.swift
//  TeamUp
//
//  Created by alihizardere on 29.07.2024.
//

import UIKit

final class CreateMatchViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var players = [Player]()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PlayerCell.identifier, bundle: nil), forCellReuseIdentifier: PlayerCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPlayers()
    }
    
    //MARK: - Private Functions
    private func fetchPlayers() {
        FirebaseService.shared.fetchPlayerKeys { keys in
            self.players.removeAll()
            let group = DispatchGroup() // Added DispatchGroup to wait for all async tasks to complete
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
    
    //MARK: - Button Actions
    @IBAction func createMatchButtonTapped(_ sender: Any) {
        let matchDetailVC = MatchDetailViewController(nibName: "MatchDetailViewController", bundle: nil)
        navigationController?.pushViewController(matchDetailVC, animated: true)
    }
}

   //MARK: - Extension TableViewDelegate && TableViewDataSource
extension CreateMatchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.identifier, for: indexPath) as? PlayerCell else { return UITableViewCell() }
        let player = players[indexPath.row]
        cell.configure(with: player)
        return cell
    }
}
