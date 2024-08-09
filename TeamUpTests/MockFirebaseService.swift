//
//  MockFirebaseService.swift
//  TeamUpTests
//
//  Created by Doğukan Temizyürek on 9.08.2024.
//

import XCTest
@testable import TeamUp

// Mock Firebase Service
final class MockFirebaseService: FirebaseServiceProtocol {
    var players: [Player] = []
    
    var fetchPlayersResult: [Player] = []
    var deletePlayerResult: Result<Void, Error> = .success(())
    var uploadPlayerResult: Result<Void, Error> = .success(())
    var updatePlayerResult: Result<Void, Error> = .success(())
    
    var fetchPlayersCalled = false
    var uploadPlayerCalled = false
    var updatePlayerCalled = false
    var deletePlayerCalled = false
    
    func uploadPlayer(imageData: Data?, player: Player?, sportType: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        uploadPlayerCalled = true
        completion(uploadPlayerResult)    }
    
    func fetchPlayers(sportType: String?, completion: @escaping ([Player]) -> Void) {
        fetchPlayersCalled = true
        completion(players)
    }
    
    func updatePlayer(_ player: Player?, sportType: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        deletePlayerCalled = true
        completion(deletePlayerResult)    }
    
    func deletePlayer(_ player: Player?, sportType: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        deletePlayerCalled = true
        completion(.success(()))
    }
}
