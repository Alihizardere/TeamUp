//
//  CreateMatchViewController.swift
//  TeamUp
//
//  Created by alihizardere on 29.07.2024.
//

import UIKit
import CoreLocation

final class CreateMatchViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var matchDateTextField: UITextField!
    @IBOutlet weak var hostIbanTextField: UITextField!
    @IBOutlet weak var gameTypeTextField: UITextField!
    @IBOutlet weak var hostNameTextField: UITextField!
    @IBOutlet weak var createMatchButton: UIButton!
    
    // MARK: - Properties
    private let pickerView = UIPickerView()
    private let datePicker = UIDatePicker()
    private let ibanMaxLength = 26
    private var activeTextField: UITextField?
    private var viewModel: CreateMatchViewModelProtocol = CreateMatchViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupViewModel()
        setupTapGesture()
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        setupPickerView()
        setupDatePicker()
        setupTextFields()
        updateCreateButtonState()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        hourTextField.inputView = pickerView
        gameTypeTextField.inputView = pickerView
        hourTextField.inputAccessoryView = createToolbar()
        gameTypeTextField.inputAccessoryView = createToolbar()
    }
    
    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        matchDateTextField.inputView = datePicker
        matchDateTextField.inputAccessoryView = createToolbar()
    }
    
    private func setupTextFields() {
        hostIbanTextField.rightView = createPasteButton()
        hostIbanTextField.rightViewMode = .always
        hostIbanTextField.delegate = self
        hourTextField.delegate = self
        gameTypeTextField.delegate = self
    }
    
    private func createPasteButton() -> UIButton {
        let pasteButton = UIButton(type: .system)
        pasteButton.setImage(UIImage(systemName: "doc.on.clipboard"), for: .normal)
        pasteButton.tintColor = .systemGray
        pasteButton.addTarget(self, action: #selector(pasteIban), for: .touchUpInside)
        return pasteButton
    }
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(doneButtonTapped))
        ], animated: false)
        return toolbar
    }
    
    private func updateCreateButtonState() {
        createMatchButton.isEnabled = viewModel.createButtonIsEnabled
    }
    
    @objc private func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        matchDateTextField.text = formatter.string(from: datePicker.date)
        viewModel.setField(field: .matchDate, value: matchDateTextField.text)
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc private func pasteIban() {
        if let pasteString = UIPasteboard.general.string {
            hostIbanTextField.text = pasteString
            viewModel.setField(field: .hostIban, value: pasteString)
        }
    }
    
    @IBAction func createMatchButtonTapped(_ sender: Any) {
        if viewModel.validateFields() {
            saveToUserDefaults()
            let setTeamsVC = SetPlayers(nibName: "SetPlayers", bundle: nil)
            navigationController?.pushViewController(setTeamsVC, animated: true)
        } else {
            UIAlertController.showAlert(on: self, title: "Eksik Bilgi", message: "Lütfen tüm alanları doldurun", primaryButtonTitle: "Tamam")
        }
    }
    
    private func saveToUserDefaults() {
        let textFields: [String: UITextField] = [
            "location": locationTextField,
            "hour": hourTextField,
            "matchDate": matchDateTextField,
            "hostName": hostNameTextField,
            "hostIban": hostIbanTextField,
            "gameType": gameTypeTextField
        ]
        
        let defaults = UserDefaults.standard
        textFields.forEach { key, textField in
            defaults.set(textField.text, forKey: key)
        }
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension CreateMatchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch activeTextField {
        case hourTextField:
            return Constants.hours.count
        case gameTypeTextField:
            return Constants.gameType.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch activeTextField {
        case hourTextField:
            return Constants.hours[row]
        case gameTypeTextField:
            return Constants.gameType[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch activeTextField {
        case hourTextField:
            let selectedHour = Constants.hours[row]
            hourTextField.text = selectedHour
            viewModel.setField(field: .hour, value: selectedHour)
        case gameTypeTextField:
            let selectedGameType = Constants.gameType[row]
            gameTypeTextField.text = selectedGameType
            viewModel.setField(field: .gameType, value: selectedGameType)
        default:
            break
        }
        doneButtonTapped()
    }
}

// MARK: - UITextFieldDelegate
extension CreateMatchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        pickerView.reloadAllComponents()
        
        if textField == hostIbanTextField {
            textField.text = String(repeating: " ", count: 1)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == hostIbanTextField {
            let characterSet = CharacterSet(charactersIn: "0123456789")
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let isNumeric = characterSet.isSuperset(of: typedCharacterSet)
            let newLength = (textField.text?.count ?? 0) + string.count - range.length
            return isNumeric && newLength <= ibanMaxLength
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case locationTextField:
            viewModel.setField(field: .location, value: textField.text)
        case hourTextField:
            viewModel.setField(field: .hour, value: textField.text)
        case matchDateTextField:
            viewModel.setField(field: .matchDate, value: textField.text)
        case hostIbanTextField:
            viewModel.setField(field: .hostIban, value: textField.text)
        case gameTypeTextField:
            viewModel.setField(field: .gameType, value: textField.text)
        case hostNameTextField:
            viewModel.setField(field: .hostName, value: textField.text)
        default:
            break
        }
        updateCreateButtonState()
    }
}

// MARK: - CreateMatchViewModelDelegate
extension CreateMatchViewController: CreateMatchViewModelDelegate {
    func didUpdateCreateButtonState(isEnabled: Bool) {
        createMatchButton.isEnabled = isEnabled
    }
}
