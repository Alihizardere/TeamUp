//
//  PlayerListTests.swift
//  TeamUpTests
//
//  Created by Doğukan Temizyürek on 9.08.2024.
//

import XCTest
@testable import TeamUp

final class PlayerListViewModelTests: XCTestCase {
    
    private var viewModel: PlayerListViewModel!
    private var mockFirebaseService: MockFirebaseService!
    private var mockDelegate: MockPlayerListViewModelDelegate!

    override func setUp() {
        super.setUp()
        mockFirebaseService = MockFirebaseService()
        mockDelegate = MockPlayerListViewModelDelegate()
        viewModel = PlayerListViewModel(firebaseService: mockFirebaseService)
        viewModel.delegate = mockDelegate
    }

    override func tearDown() {
        viewModel = nil
        mockFirebaseService = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testLoadPlayersCallsDelegateMethodsInCorrectOrder() {
        let players = [
            Player(id: "1", name: "John", surname: "Doe", imageUrl: "url", position: "Forward", overall: 90),
            Player(id: "2", name: "Jane", surname: "Smith", imageUrl: "url", position: "Midfielder", overall: 85)
        ]
        mockFirebaseService.fetchPlayersResult = players
        viewModel.load(sportType: "football")
        
        XCTAssertTrue(mockFirebaseService.fetchPlayersCalled, "fetchPlayers should be called.")
        XCTAssertTrue(mockDelegate.showLoadingViewCalled, "showLoadingView should be called before fetching players.")
        XCTAssertTrue(mockDelegate.hideLoadingViewCalled, "hideLoadingView should be called after fetching players.")
        XCTAssertTrue(mockDelegate.reloadDataCalled, "reloadData should be called after players are fetched.")
    }



    func testDeletePlayerRemovesPlayerAndUpdatesView() {
        let player = Player(id: "1", name: "John", surname: "Doe", imageUrl: "url", position: "Forward", overall: 90)
        mockFirebaseService.players = [player]
        viewModel.load(sportType: "football")
        
        XCTAssertEqual(viewModel.numberOfItems, 1, "There should be 1 player before deletion.")
        viewModel.delete(at: IndexPath(row: 0, section: 0), sportType: "football")
        XCTAssertTrue(mockFirebaseService.deletePlayerCalled, "deletePlayer should be called.")
        XCTAssertTrue(mockDelegate.deleteRowsCalled, "deleteRows should be called when a player is deleted.")
        XCTAssertEqual(viewModel.numberOfItems, 0, "There should be 0 players after deletion.")
    }
    
    func testShowEmptyViewWhenNoPlayersFetched() {
        mockFirebaseService.fetchPlayersResult = []
        
        viewModel.load(sportType: "football")
        
        XCTAssertTrue(mockFirebaseService.fetchPlayersCalled, "fetchPlayers should be called.")
        XCTAssertEqual(viewModel.numberOfItems, 0, "Number of items should be 0 when no players are fetched.")
        XCTAssertTrue(mockDelegate.showEmptyViewCalled, "showEmptyView should be called when there are no players.")
        XCTAssertTrue(mockDelegate.reloadDataCalled, "reloadData should still be called even when there are no players.")
    }
}
