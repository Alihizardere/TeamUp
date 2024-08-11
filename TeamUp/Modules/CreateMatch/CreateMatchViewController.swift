//
//  CreateMatchViewController.swift
//  TeamUp
//
//  Created by alihizardere on 29.07.2024.
//

import UIKit
import CoreLocation

final class CreateMatchViewController: UIViewController {
    
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var districtTextField: UITextField!
    @IBOutlet private weak var hourTextField: UITextField!
    @IBOutlet private weak var matchDateTextField: UITextField!
    @IBOutlet private weak var hostIbanTextField: UITextField!
    @IBOutlet private weak var gameTypeTextField: UITextField!
    @IBOutlet private weak var hostNameTextField: UITextField!
    @IBOutlet private weak var createMatchButton: UIButton!
    
    // MARK: - PROPERTIES
    
    private let pickerView = UIPickerView()
    private let datePicker = UIDatePicker()
    private let ibanMaxLength = 26
    private var activeTextField: UITextField?
    private var viewModel: CreateMatchViewModelProtocol = CreateMatchViewModel()
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
        configureUI()
        setupViewModel()
        setupTapGesture()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
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
        cityTextField.inputView = pickerView
        districtTextField.inputView = pickerView
        hourTextField.inputView = pickerView
        gameTypeTextField.inputView = pickerView
        cityTextField.inputAccessoryView = createToolbar()
        districtTextField.inputAccessoryView = createToolbar()
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
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        ], animated: false)
        return toolbar
    }
    
    private func saveToUserDefaults() {
        let textFields: [String: UITextField] = [
            "city": cityTextField,
            "district": districtTextField,
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
    
    @IBAction func createMatchButtonTapped(_ sender: UIButton) {
        if viewModel.validateFields() {
            saveToUserDefaults()
            let setTeamsVC = SetPlayersViewController(nibName: "SetPlayersViewController", bundle: nil)
            setTeamsVC.gameType = viewModel.gameType
            navigationController?.pushViewController(setTeamsVC, animated: true)
        } else {
            UIAlertController.showAlert(
                on: self,
                title: "Eksik Bilgi",
                message: "Lütfen tüm alanları doldurun",
                primaryButtonTitle: "Tamam"
            )
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
        case cityTextField:
            return viewModel.cities.count
        case districtTextField:
            return viewModel.districts.count
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
        case cityTextField:
            return viewModel.cities[row]
        case districtTextField:
            return viewModel.districts[row]
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
        case cityTextField:
            let selectedCityName = viewModel.cities[row]
            cityTextField.text = viewModel.cities[row]
            viewModel.setField(field: .city, value: selectedCityName)
            if let selectedCityID = viewModel.cities.first(where: { $0.value == selectedCityName})?.key {
                viewModel.fetchDistricts(for: selectedCityID)
            }
        case districtTextField:
            let selectedDistrict = viewModel.districts[row]
            districtTextField.text = selectedDistrict
            viewModel.setField(field: .district, value: selectedDistrict)
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
        switch textField {
        case hostIbanTextField:
            let characterSet = CharacterSet(charactersIn: "0123456789")
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let isNumeric = characterSet.isSuperset(of: typedCharacterSet)
            let newLength = (textField.text?.count ?? 0) + string.count - range.length
            return isNumeric && newLength <= ibanMaxLength
            
        case cityTextField, districtTextField,gameTypeTextField,matchDateTextField,hourTextField:
            return false
        case hostNameTextField:
            let allowedCharacters = CharacterSet.letters.union(CharacterSet.whitespaces)
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        default:
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case cityTextField:
            viewModel.setField(field: .city, value: textField.text)
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

