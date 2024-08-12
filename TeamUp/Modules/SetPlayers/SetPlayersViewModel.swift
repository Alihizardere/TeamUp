//
//  SetPlayersViewModel.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 8.08.2024.
//
import Foundation

// MARK: - SetPlayersViewModelDelegate

protocol SetPlayersViewModelDelegate: AnyObject {
    func setupUI()
    func reloadData()
    func showEmptyView()
    func hideEmptyView()
    func showLoadingView()
    func hideLoadingView()
    func showErrorAlert()
}

protocol SetPlayersViewModelProtocol {
    var players: [Player] { get set }
    var numberOfItems: Int { get }
    var delegate: SetPlayersViewModelDelegate? { get set }
    func loadPlayers(for sportType: String)
    func viewDidLoad()
    func player(at indexPath: IndexPath) -> Player?
    func removePlayer(at index: Int) -> Player?
    func removePlayers(_ players: [Player])
    func undoLastPlayerAddition()
    func restoreAllPlayers()
}

// MARK: - SetPlayersViewModel

final class SetPlayersViewModel {
    weak var delegate: SetPlayersViewModelDelegate?
    private let firebaseService: FirebaseServiceProtocol
    var players: [Player] = []
    private var addedPlayersHistory: [(player: Player, index: Int)] = []
    init(firebaseService: FirebaseServiceProtocol = FirebaseService()) {
        self.firebaseService = firebaseService
    }
    
    private func fetchPlayers(for sportType: String) {
        delegate?.showLoadingView()
        firebaseService.fetchPlayers(sportType: sportType) { [weak self] players in
            guard let self = self else { return }
            self.players = players
            self.delegate?.hideLoadingView()
            if self.players.isEmpty {
                self.delegate?.showEmptyView()
            } else {
                self.delegate?.hideEmptyView()
            }
            self.delegate?.reloadData()
        }
    }
}

// MARK: - SetPlayersViewModelProtocol

extension SetPlayersViewModel: SetPlayersViewModelProtocol {
    
    func viewDidLoad() {
        delegate?.setupUI()
    }
    
    var numberOfItems: Int {
        return players.count
    }
    
    func player(at indexPath: IndexPath) -> Player? {
        guard indexPath.item < players.count else { return nil }
        return players[indexPath.item]
    }
    
    func loadPlayers(for sportType: String) {
        fetchPlayers(for: sportType)
    }
    
    func undoLastPlayerAddition() {
        guard let lastAdded = addedPlayersHistory.popLast() else { return }
        players.insert(lastAdded.player, at: lastAdded.index)
        delegate?.reloadData()
    }
    
    func removePlayer(at index: Int) -> Player? {
        guard index >= 0 && index < players.count else { return nil }
        let removedPlayer = players.remove(at: index)
        addedPlayersHistory.append((player: removedPlayer, index: index))
        return removedPlayer
    }
    
    func removePlayers(_ players: [Player]) {
        let playerIds = Set(players.map { $0.id })
        self.players.removeAll { playerIds.contains($0.id) }
    }
    
    
    func restoreAllPlayers() {
        for history in addedPlayersHistory.reversed() {
            players.insert(history.player, at: history.index)
        }
        addedPlayersHistory.removeAll()
        delegate?.reloadData()
    }
    
}
