//
//  PlayerDetailTests.swift
//  TeamUpTests
//
//  Created by Doğukan Temizyürek on 9.08.2024.
//
import XCTest
@testable import TeamUp

final class PlayerDetailViewModelTests: XCTestCase {
    private var viewModel: PlayerDetailViewModel!
    private var mockDelegate: MockPlayerDetailViewModelDelegate!
    private var mockFirebaseService: MockFirebaseService!
    
    override func setUp() {
        super.setUp()
        viewModel = PlayerDetailViewModel()
        mockDelegate = MockPlayerDetailViewModelDelegate()
        viewModel.delegate = mockDelegate
        mockFirebaseService = MockFirebaseService()
        viewModel.firebaseService = mockFirebaseService
    }
    
    override func tearDown() {
        viewModel = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testViewDidLoadCallsSetupMethods() {
        viewModel.viewDidLoad()
        
        XCTAssertTrue(mockDelegate.setupUICalled, "setupUI should be called.")
        XCTAssertTrue(mockDelegate.setupSelectedInfoCalled, "setupSelectedInfo should be called.")
        XCTAssertTrue(mockDelegate.setupTapGestureCalled, "setupTapGesture should be called.")
    }
    
    func testUploadCallsCorrectMethods() {
        let player = Player(id: nil, name: "John", surname: "Doe", imageUrl: nil, position: "Forward", overall: 90)
        let imageData = Data()
        mockFirebaseService.uploadPlayerResult = .success(())
        
        viewModel.upload(imageData: imageData, player: player, sportType: "football")
        
        XCTAssertTrue(mockDelegate.showLoadingViewCalled, "showLoadingView should be called before uploading the player.")
        XCTAssertTrue(mockDelegate.hideLoadingViewCalled, "hideLoadingView should be called after the player is uploaded.")
        XCTAssertTrue(mockDelegate.goToPreviousPageCalled, "goToPreviousPage should be called after the player is successfully uploaded.")
    }
    
    func testUpdateCallsCorrectMethods() {
        let player = Player(id: "1", name: "John", surname: "Doe", imageUrl: nil, position: "Forward", overall: 90)
        mockFirebaseService.updatePlayerResult = .success(())
        
        viewModel.update(updatedPlayer: player, sportType: "football")
        
        XCTAssertTrue(mockDelegate.goToPreviousPageCalled, "goToPreviousPage should be called after the player is successfully updated.")
    }
    
    func testUpdatePickerDataForFootball() {
        UserDefaults.standard.setValue("football", forKey: "sportType")
        
        viewModel.updatePickerData()
        
        XCTAssertEqual(viewModel.positions, Constants.footballPositions, "Positions should match football positions.")
        XCTAssertTrue(mockDelegate.reloadPickerViewCalled, "reloadPickerView should be called after updating picker data.")
    }
}
