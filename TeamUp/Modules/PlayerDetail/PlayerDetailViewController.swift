//
//  PlayerDetailViewController.swift
//  TeamUp
//
//  Created by alihizardere on 30.07.2024.
//

import UIKit

final class PlayerDetailViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var playerName: UITextField!
  @IBOutlet weak var playerSurname: UITextField!
  @IBOutlet weak var playerPosition: UITextField!
  @IBOutlet weak var playerOverall: UITextField!
  let pickerView = UIPickerView()
  var activeTextField: UITextField?

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPickerView()
    setupTapGesture()
  }

  // MARK: -  Private Functions
  private func setupPickerView() {
    playerPosition.inputView = pickerView
    playerOverall.inputView = pickerView

    pickerView.delegate = self
    pickerView.dataSource = self

    playerPosition.delegate = self
    playerOverall.delegate = self
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
          let image = profileImage.image else { return }

    FirebaseService.shared.uploadPlayerImage(
      image,
      playerName: name,
      playerSurname: surname,
      position: position,
      overall: Int(overall)) { result in
        switch result {
        case .success():
          self.navigationController?.popViewController(animated: true)
        case .failure(let error):
          print("Error adding user: \(error.localizedDescription)")
        }
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
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch activeTextField {
    case playerPosition:
      return Constants.positions.count
    case playerOverall:
      return Constants.scores.count
    default:
      return 0
    }
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch activeTextField {
    case playerPosition:
      return Constants.positions[row]
    case playerOverall:
      return Constants.scores[row]
    default:
      return nil
    }
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch activeTextField {
    case playerPosition:
      playerPosition.text = Constants.positions[row]
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
