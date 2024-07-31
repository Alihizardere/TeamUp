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

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tapGesture()
  }

  // MARK: -  Private Functions
  private func tapGesture(){
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
        case .success(let success):
          self.navigationController?.popViewController(animated: true)
        case .failure(let error):
          print("Error adding user: \(error.localizedDescription)")
        }
      }
  }
}

// MARK: - UIImagePickerControllerDelegate && UINavigationControllerDelegate Extensions
extension PlayerDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
      profileImage.image = image
    }
    dismiss(animated: true)
  }
}
