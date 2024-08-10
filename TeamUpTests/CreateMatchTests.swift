//
//  CreateMatchTests.swift
//  TeamUpTests
//
//  Created by alihizardere on 10.08.2024.
//

import XCTest
@testable import TeamUp

final class CreateMatchViewModelTests: XCTestCase {
  private var viewModel: CreateMatchViewModel!
  private var mockDelegate:  MockCreateMatchViewModelDelegate!

  override func setUp() {
    super.setUp()
    viewModel = CreateMatchViewModel()
    mockDelegate = MockCreateMatchViewModelDelegate()
    viewModel.delegate = mockDelegate
  }

  override func tearDown() {
    super.tearDown()
    viewModel = nil
    mockDelegate = nil
  }

  func testValidateFields_withValidFields_shouldReturnTrue() {

          viewModel.setField(field: .city, value: "New York")
          viewModel.setField(field: .district, value: "Manhattan")
          viewModel.setField(field: .hour, value: "10:00 AM")
          viewModel.setField(field: .matchDate, value: "August 10, 2024")
          viewModel.setField(field: .hostIban, value: "TR123456789012345678901234")
          viewModel.setField(field: .gameType, value: "5x5")
          viewModel.setField(field: .hostName, value: "John Doe")


          let isValid = viewModel.validateFields()

          XCTAssertTrue(isValid)
          XCTAssertTrue(viewModel.createButtonIsEnabled)
          XCTAssertTrue(mockDelegate.didUpdateCreateButtonStateCalled)
    }

    func testValidateFields_withInvalidFields_shouldReturnFalse() {

            viewModel.setField(field: .city, value: nil)
            viewModel.setField(field: .hour, value: nil)
            viewModel.setField(field: .matchDate, value: nil)
            viewModel.setField(field: .hostIban, value: nil)
            viewModel.setField(field: .gameType, value: nil)
            viewModel.setField(field: .hostName, value: nil)

            let isValid = viewModel.validateFields()

            // Then
            XCTAssertFalse(isValid)
            XCTAssertFalse(viewModel.createButtonIsEnabled)
            XCTAssertTrue(mockDelegate.didUpdateCreateButtonStateCalled)
        }

        func testSetField_city_shouldUpdateLocation() {

            viewModel.setField(field: .city, value: "New York")

            XCTAssertEqual(viewModel.location, "New York")
            XCTAssertTrue(mockDelegate.didUpdateCreateButtonStateCalled)
        }

        func testSetField_district_shouldUpdateDistrict() {
            viewModel.setField(field: .district, value: "Manhattan")

            XCTAssertEqual(viewModel.district, "Manhattan")
            XCTAssertTrue(mockDelegate.didUpdateCreateButtonStateCalled)
        }

        func testSetField_matchDate_shouldUpdateMatchDate() {

            viewModel.setField(field: .matchDate, value: "August 10, 2024")

            XCTAssertNotNil(viewModel.matchDate)
            XCTAssertTrue(mockDelegate.didUpdateCreateButtonStateCalled)
        }

        func testSetField_invalidMatchDate_shouldSetMatchDateToNil() {

            viewModel.setField(field: .matchDate, value: "Invalid Date")

            XCTAssertNil(viewModel.matchDate)
            XCTAssertTrue(mockDelegate.didUpdateCreateButtonStateCalled)
        }

        func testFetchCities_shouldUpdateCities() {

            let expectation = XCTestExpectation(description: "Fetch Cities")

            viewModel.load()

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                XCTAssertFalse(self.viewModel.cities.isEmpty)
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 5.0)
        }

        func testFetchDistricts_shouldUpdateDistricts() {
            let cityID = 1
            let expectation = XCTestExpectation(description: "Fetch Districts")

            viewModel.fetchDistricts(for: cityID)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                XCTAssertFalse(self.viewModel.districts.isEmpty)
                expectation.fulfill()
            }

            wait(for: [expectation], timeout: 5.0)
        }
}
