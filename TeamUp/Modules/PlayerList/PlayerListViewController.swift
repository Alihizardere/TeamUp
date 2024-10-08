//
//  PlayerListViewController.swift
//  TeamUp
//
//  Created by alihizardere on 29.07.2024.
//

import UIKit

final class PlayerListViewController: BaseViewController {

    // MARK: - OUTLETS

    @IBOutlet weak var tableView: UITableView!

    // MARK: - PROPERTIES

    private var viewModel: PlayerListViewModelProtocol = PlayerListViewModel()

    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewDidLoad()
    }

    // MARK: - ACTIONS

    @IBAction func addPlayerButtonTapped(_ sender: Any) {
        let playerDetailVC: PlayerDetailViewController = UIViewController.instantiate(from: .playerDetail )
        navigationController?.pushViewController(playerDetailVC, animated: true)
    }
}

// MARK: - UITableViewDelegate && UITableViewDataSource

extension PlayerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.identifier, for: indexPath) as? PlayerCell else { return UITableViewCell() }
        if let player = viewModel.player(index: indexPath) {
            cell.configure(with: player, index: indexPath)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let player = viewModel.player(index: indexPath) {
            let playerDetailVC: PlayerDetailViewController = UIViewController.instantiate(from: .playerDetail)
            playerDetailVC.selectedPlayer = player
            navigationController?.pushViewController(playerDetailVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let self else { return }
            guard let sportType = UserDefaults.standard.string(forKey: Constants.SportType.key) else { return }

            UIAlertController.showAlert(
                on: self,
                title: "Delete Player",
                message: "Are you sure you want to delete the player?",
                primaryButtonTitle: "OK",
                primaryButtonStyle: .destructive,
                primaryButtonHandler: {
                    self.viewModel.delete(at: indexPath, sportType: sportType)
                },
                secondaryButtonTitle: "Cancel")
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - PlayerListViewModelDelegates

extension PlayerListViewController: PlayerListViewModelDelegate {

    func setupUI() {
        tableView.register(
            UINib(nibName: PlayerCell.identifier, bundle: nil),
            forCellReuseIdentifier: PlayerCell.identifier
        )
        guard let sportType = UserDefaults.standard.string(forKey: "sportType") else { return }
        viewModel.load(sportType: sportType)
        navigationController?.navigationBar.isHidden = false
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func showEmptyView() {
        self.tableView.setEmptyView(
            title: "No Players Yet",
            message: "Add new players to get started!",
            image: UIImage(named: "no-results")
        )
    }

    func hideEmptyView() {
        self.tableView.restore()
    }

    func showLoadingView() {
        showLoading()
    }

    func hideLoadingView() {
        hideLoading()
    }

    func deleteRows(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    func showErrorAlert() {
        UIAlertController.showAlert(
            on: self,
            title: "Delete",
            message: "Deletion failed, try again."
        )
    }
}
