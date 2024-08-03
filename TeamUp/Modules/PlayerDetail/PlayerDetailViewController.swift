//
//  PlayerDetailViewController.swift
//  TeamUp
//
//  Created by alihizardere on 30.07.2024.
//

import UIKit
import Kingfisher

final class PlayerDetailViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var playerName: UITextField!
  @IBOutlet weak var playerSurname: UITextField!
  @IBOutlet weak var playerPosition: UITextField!
  @IBOutlet weak var playerOverall: UITextField!
  @IBOutlet weak var addPlayerButton: UIButton!
  let pickerView = UIPickerView()
  var activeTextField: UITextField?
  var selectedPlayer: Player?
  var positions = [String]()

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSelectedInfo()
    setupPickerView()
    setupTapGesture()
  }

  // MARK: -  Private Functions
  private func setupSelectedInfo(){
    guard let player = selectedPlayer else { return }
    playerName.text = player.name
    playerSurname.text = player.surname
    playerPosition.text = player.position
    if let overall = player.overall,
       let url = URL(string: player.imageUrl ?? ""){
      playerOverall.text = String(overall)
      profileImage.kf.setImage(with: url)
    }
    addPlayerButton.setTitle("Güncelle", for: .normal)
  }

  private func setupPickerView() {
    playerPosition.inputView = pickerView
    playerOverall.inputView = pickerView

    pickerView.delegate = self
    pickerView.dataSource = self
    
    playerPosition.delegate = self
    playerOverall.delegate = self

    updatePickerData()
  }

  private func updatePickerData() {
    guard let sportType = UserDefaults.standard.string(forKey: "sportType") else { return }

    switch sportType {
    case "football":
      positions = Constants.footballPositions
    case "volleyball":
      positions = Constants.volleyballPositions
    default:
      positions = []
    }
    pickerView.reloadAllComponents()
  }

  private func setupTapGesture() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    profileImage.isUserInteractionEnabled = true
    profileImage.addGestureRecognizer(tap)
  }

  @objc private func imageTapped() {
    let picker = UIImagePickerController()
    picker.delegate = self
    present(picker, animated: true)
  }

  @IBAction func addPlayerButtonTapped(_ sender: Any) {
    guard let name = playerName.text, !name.isEmpty,
          let surname = playerSurname.text, !surname.isEmpty,
          let position = playerPosition.text, !position.isEmpty,
          let overall = playerOverall.text, !overall.isEmpty,
          let sportType = UserDefaults.standard.string(forKey: "sportType") else { return }

    if let image = profileImage.image {
      if let player = selectedPlayer {

        let updatedPlayer = Player(
          id: player.id,
          name: name,
          surname: surname,
          imageUrl: player.imageUrl,
          position: position,
          overall: Int(overall)
        )

        FirebaseService.shared.updatePlayer(
          updatedPlayer,
          sportType: sportType) { result in
            switch result {
            case .success():
              self.navigationController?.popViewController(animated: true)
            case .failure(let error):
              print("Error updating player: \(error.localizedDescription)")
            }
          }
      } else {
        FirebaseService.shared.uploadPlayerImage(
          image,
          playerName: name,
          playerSurname: surname,
          position: position,
          overall: Int(overall),
          sportType: sportType) { result in
            switch result {
            case .success():
              self.navigationController?.popViewController(animated: true)
            case .failure(let error):
              print("Error adding player: \(error.localizedDescription)")
            }
          }
      }
    } else {
      print("Image is required.")
    }
  }
}

// MARK: - UIImagePickerControllerDelegate && UINavigationControllerDelegate
extension PlayerDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
      profileImage.image = image
    }
    dismiss(animated: true)
  }
}

// MARK: - UIPickerViewDelegate && UIPickerViewDataSource
extension PlayerDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
     1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch activeTextField {
    case playerPosition:
      return positions.count
    case playerOverall:
      return Constants.scores.count
    default:
      return 0
    }
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch activeTextField {
    case playerPosition:
      return positions[row]
    case playerOverall:
      return Constants.scores[row]
    default:
      return nil
    }
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch activeTextField {
    case playerPosition:
      playerPosition.text = positions[row]
    case playerOverall:
      playerOverall.text = Constants.scores[row]
    default:
      return
    }
    view.endEditing(true)
  }
}

// MARK: - UITextFieldDelegate
extension PlayerDetailViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeTextField = textField
    pickerView.reloadAllComponents()
  }
}
