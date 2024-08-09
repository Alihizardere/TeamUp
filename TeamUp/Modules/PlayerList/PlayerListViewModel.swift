//
//  PlayerListViewModel.swift
//  TeamUp
//
//  Created by alihizardere on 6.08.2024.
//

import Foundation

// MARK: - PlayerListViewModelDelegates

protocol PlayerListViewModelDelegate: AnyObject {
    func reloadData()
    func setupUI()
    func showEmptyView()
    func hideEmptyView()
    func showLoadingView()
    func hideLoadingView()
    func deleteRows(at index: IndexPath)
    func showErrorAlert()
}

protocol PlayerListViewModelProtocol {
    var delegate: PlayerListViewModelDelegate? { get set }
    func viewDidLoad()
    func load(sportType: String)
    var numberOfItems: Int { get }
    func player(index: IndexPath) -> Player?
    func delete(at index: IndexPath, sportType: String)
}

// MARK: - PlayerListViewModel

final class PlayerListViewModel {
    weak var delegate: PlayerListViewModelDelegate?
    fileprivate var firebaseService: FirebaseServiceProtocol = FirebaseService()
    var players = [Player]()
    
    init(firebaseService: FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }
    
    fileprivate func fetchPlayers(sportType: String) {
        self.delegate?.showLoadingView()
        firebaseService.fetchPlayers(sportType: sportType) { [weak self] players in
            guard let self else { return }
            self.players = players
            delegate?.reloadData()
            delegate?.hideLoadingView()
            if self.players.isEmpty {
                delegate?.showEmptyView()
            } else {
                delegate?.hideEmptyView()
            }
        }
    }
    
    fileprivate func deletePlayer(at indexPath: IndexPath, sportType: String) {
        let player = players[indexPath.row]
        self.players.remove(at: indexPath.row)
        self.delegate?.deleteRows(at: indexPath)
        firebaseService.deletePlayer(player, sportType: sportType) { result in
            switch result {
            case .success(let success):
                print("delete player \(success)")
            case .failure:
                self.delegate?.showErrorAlert()
            }
        }
    }
    
}

// MARK: - PlayerListViewModelProtocols

extension PlayerListViewModel: PlayerListViewModelProtocol {
    
    func viewDidLoad() {
        delegate?.setupUI()
    }
    
    func load(sportType: String) {
        fetchPlayers(sportType: sportType)
    }
    
    var numberOfItems: Int {
        players.count
    }
    
    func player(index: IndexPath) -> Player? {
        players[index.row]
    }
    
    func delete(at indexPath: IndexPath, sportType: String) {
        deletePlayer(at: indexPath, sportType: sportType)
    }
}
