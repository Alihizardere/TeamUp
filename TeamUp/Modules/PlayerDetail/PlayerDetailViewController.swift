//
//  PlayerDetailViewController.swift
//  TeamUp
//
//  Created by alihizardere on 30.07.2024.
//

import UIKit
import Kingfisher

final class PlayerDetailViewController: BaseViewController {

    // MARK: - PROPERTIES

    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var playerName: UITextField!
    @IBOutlet private weak var playerSurname: UITextField!
    @IBOutlet private weak var playerPosition: UITextField!
    @IBOutlet private weak var playerOverall: UITextField!
    @IBOutlet private weak var addPlayerButton: UIButton!
    private let pickerView = UIPickerView()
    private var activeTextField: UITextField?
    var selectedPlayer: Player?
    private var viewModel: PlayerDetailViewModelProtocol = PlayerDetailViewModel()

    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewDidLoad()
    }

    // MARK: - PRIVATE FUNCTIONS

    @objc private func imageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - ACTIONS

    @IBAction  private func addPlayerButtonTapped(_ sender: Any) {
        guard let name = playerName.text, !name.isEmpty,
              let surname = playerSurname.text, !surname.isEmpty,
              let position = playerPosition.text, !position.isEmpty,
              let overall = playerOverall.text, !overall.isEmpty,
              let sportType = UserDefaults.standard.string(forKey: Constants.SportType.key) else { return UIAlertController.showAlert(
                on: self,
                title: "Incomplete Information",
                message: "Please ensure all fields are filled out before proceeding.",
                primaryButtonTitle: "OK",
                primaryButtonStyle: .default
            )
        }

        if let image = profileImage.image, let imageData = image.jpegData(compressionQuality: 0.5) {
            if let player = selectedPlayer {
                let updatedPlayer = Player(
                    id: player.id,
                    name: name,
                    surname: surname,
                    imageUrl: player.imageUrl,
                    position: position,
                    overall: Int(overall)
                )
                viewModel.update(updatedPlayer: updatedPlayer, sportType: sportType)

            } else {
                let newPlayer = Player(
                    id: nil,
                    name: name,
                    surname: surname,
                    imageUrl: nil,
                    position: position,
                    overall: Int(overall)
                )
                viewModel.upload(
                    imageData: imageData,
                    player: newPlayer,
                    sportType: sportType
                )
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
            return viewModel.positions.count
        case playerOverall:
            return Constants.scores.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch activeTextField {
        case playerPosition:
            return viewModel.positions[row]
        case playerOverall:
            return Constants.scores[row]
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch activeTextField {
        case playerPosition:
            playerPosition.text = viewModel.positions[row]
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
        pickerView.selectRow(0, inComponent: 0, animated: false)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == playerPosition || textField == playerOverall {
            return false
        } else if textField == playerName || textField == playerSurname {
            let allowedCharacters = CharacterSet.letters
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}

// MARK: - PlayerDetailViewModelDelegates

extension PlayerDetailViewController: PlayerDetailViewModelDelegate {

    func setupUI() {
        playerPosition.inputView = pickerView
        playerOverall.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        profileImage.layer.borderColor = UIColor.darkGray.cgColor
        profileImage.layer.borderWidth = 1
        viewModel.updatePickerData()
    }

    func setupSelectedInfo() {
        guard let player = selectedPlayer else { return }
        playerName.text = player.name
        playerSurname.text = player.surname
        playerPosition.text = player.position
        if let overall = player.overall,
           let url = URL(string: player.imageUrl ?? ""){
            playerOverall.text = String(overall)
            profileImage.kf.setImage(with: url)
        }
        addPlayerButton.setTitle("Update", for: .normal)
    }

    func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        let tapForDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapForDismissKeyboard)
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tap)
    }

    func showLoadingView() {
        showLoading()
    }

    func hideLoadingView() {
        hideLoading()
    }

    func goToPreviousPage() {
        navigationController?.popViewController(animated: true)
    }

    func reloadPickerView() {
        pickerView.reloadAllComponents()
    }
}
