//
//  PlayerDetailViewModel.swift
//  TeamUp
//
//  Created by alihizardere on 7.08.2024.
//
import Foundation

// MARK: - PlayerDetailViewModelDelegates

protocol PlayerDetailViewModelDelegate: AnyObject {
    func setupUI()
    func setupSelectedInfo()
    func setupTapGesture()
    func showLoadingView()
    func hideLoadingView()
    func goToPreviousPage()
    func reloadPickerView()
}

protocol PlayerDetailViewModelProtocol {
    var delegate: PlayerDetailViewModelDelegate? { get set }
    var positions: [String] { get set }
    func viewDidLoad()
    func update(updatedPlayer: Player?, sportType: String?)
    func upload(imageData: Data?, player: Player?, sportType: String?)
    func updatePickerData()
}

// MARK: - PlayerDetailViewModel

final class PlayerDetailViewModel {
    weak var delegate: PlayerDetailViewModelDelegate?
    var positions = [String]()
    var firebaseService: FirebaseServiceProtocol = FirebaseService()
    
    fileprivate func uploadPlayer(imageData: Data, player: Player, sportType: String){
        delegate?.showLoadingView()
        firebaseService.uploadPlayer(
            imageData: imageData,
            player: player,
            sportType: sportType) { result in
                self.delegate?.hideLoadingView()
                switch result {
                case .success():
                    self.delegate?.goToPreviousPage()
                case .failure(let error):
                    print("Error adding player: \(error.localizedDescription)")
                }
            }
    }
    
    fileprivate func updatePlayer(updatedPlayer: Player, sportType: String) {
        firebaseService.updatePlayer(
            updatedPlayer,
            sportType: sportType) { result in
                switch result {
                case .success():
                    self.delegate?.goToPreviousPage()
                case .failure(let error):
                    print("Error updating player: \(error.localizedDescription)")
                }
            }
    }
}

// MARK: - PlayerDetailViewModelProtocol

extension PlayerDetailViewModel: PlayerDetailViewModelProtocol {
    
    func viewDidLoad() {
        delegate?.setupUI()
        delegate?.setupSelectedInfo()
        delegate?.setupTapGesture()
    }
    
    func upload(imageData: Data?, player: Player?, sportType: String?) {
        guard let imageData, let player, let sportType else { return }
        uploadPlayer(imageData: imageData, player: player, sportType: sportType)
    }
    
    func update(updatedPlayer: Player?, sportType: String?) {
        guard let updatedPlayer, let sportType else { return }
        updatePlayer(updatedPlayer: updatedPlayer, sportType: sportType)
    }
    
    func updatePickerData() {
      if let sportType = UserDefaults.standard.sportType(forKey: Constants.SportType.key) {
        switch sportType {
        case .football:
          positions = Constants.footballPositions
        case .volleyball:
          positions = Constants.volleyballPositions
        }
      }
        delegate?.reloadPickerView()
    }
}
