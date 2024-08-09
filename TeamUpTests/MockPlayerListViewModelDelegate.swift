//
//  MockPlayerListViewModelDelegate.swift
//  TeamUpTests
//
//  Created by Doğukan Temizyürek on 9.08.2024.
//
import XCTest
@testable import TeamUp

final class MockPlayerListViewModelDelegate: PlayerListViewModelDelegate {
    var reloadDataCalled = false
    var setupUICalled = false
    var showEmptyViewCalled = false
    var hideEmptyViewCalled = false
    var showLoadingViewCalled = false
    var hideLoadingViewCalled = false
    var deleteRowsCalled = false
    var showErrorAlertCalled = false
    
    func reloadData() {
        reloadDataCalled = true
    }
    
    func setupUI() {
        setupUICalled = true
    }
    
    func showEmptyView() {
        showEmptyViewCalled = true
    }
    
    func hideEmptyView() {
        hideEmptyViewCalled = true
    }
    
    func showLoadingView() {
        showLoadingViewCalled = true
    }
    
    func hideLoadingView() {
        hideLoadingViewCalled = true
    }
    
    func deleteRows(at index: IndexPath) {
        deleteRowsCalled = true
    }
    
    func showErrorAlert() {
        showErrorAlertCalled = true
    }
}
