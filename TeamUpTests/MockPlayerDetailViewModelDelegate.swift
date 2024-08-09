//
//  MockPlayerDetailViewModelDelegate.swift
//  TeamUpTests
//
//  Created by Doğukan Temizyürek on 9.08.2024.
//

import XCTest
@testable import TeamUp

final class MockPlayerDetailViewModelDelegate: PlayerDetailViewModelDelegate {
    var setupUICalled = false
    var setupSelectedInfoCalled = false
    var setupTapGestureCalled = false
    var showLoadingViewCalled = false
    var hideLoadingViewCalled = false
    var goToPreviousPageCalled = false
    var reloadPickerViewCalled = false

    func setupUI() {
        setupUICalled = true
    }

    func setupSelectedInfo() {
        setupSelectedInfoCalled = true
    }

    func setupTapGesture() {
        setupTapGestureCalled = true
    }

    func showLoadingView() {
        showLoadingViewCalled = true
    }

    func hideLoadingView() {
        hideLoadingViewCalled = true
    }
  
    func goToPreviousPage() {
        goToPreviousPageCalled = true
    }

    func reloadPickerView() {
        reloadPickerViewCalled = true
    }
}


