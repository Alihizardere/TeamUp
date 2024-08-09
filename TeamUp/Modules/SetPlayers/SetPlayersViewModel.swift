//
//  SetPlayersViewModel.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 8.08.2024.
//
import Foundation

protocol SetPlayersViewModelDelegate: AnyObject {
    func reloadData()
    func showEmptyView()
    func setupUI()
    func hideEmptyView()
    func showLoadingView()
    func hideLoadingView()
    func showErrorAlert()
}

protocol SetPlayersViewModelProtocol {
    var players: [Player] { get }
    var numberOfItems: Int { get }
    var delegate: SetPlayersViewModelDelegate? { get set }
    func loadPlayers(for sportType: String)
    func viewDidLoad()
    func player(at indexPath: IndexPath) -> Player?
    func removePlayer(at index: Int) -> Player?
    func undoLastPlayerAddition()
}

final class SetPlayersViewModel {
    weak var delegate: SetPlayersViewModelDelegate?
    private let firebaseService: FirebaseServiceProtocol
    private(set) var players: [Player] = []
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
}