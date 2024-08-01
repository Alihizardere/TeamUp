//
//  CreateMatchViewController.swift
//  TeamUp
//
//  Created by alihizardere on 29.07.2024.
//

import UIKit
import CoreLocation

final class CreateMatchViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTemprature: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var tempImage: UIImageView!
    
    var players = [Player]()
    private let locationManager = CLLocationManager()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPlayers()
    }
    
    //MARK: - Private Functions
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PlayerCell.identifier, bundle: nil), forCellReuseIdentifier: PlayerCell.identifier)
    }
    
    private func fetchPlayers() {
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
