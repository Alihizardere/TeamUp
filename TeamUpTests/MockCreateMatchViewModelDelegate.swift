//
//  MockCreateMatchViewModelDelegate.swift
//  TeamUpTests
//
//  Created by alihizardere on 10.08.2024.
//

import XCTest
@testable import TeamUp

final class MockCreateMatchViewModelDelegate: CreateMatchViewModelDelegate {
  var didUpdateCreateButtonStateCalled = false


  func didUpdateCreateButtonState(isEnabled: Bool) {
    didUpdateCreateButtonStateCalled = true

  }
}
