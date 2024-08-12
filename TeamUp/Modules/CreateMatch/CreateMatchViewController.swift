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
    
    @IBOutlet private weak var cityTextField: CustomTextField!
    @IBOutlet private weak var districtTextField: CustomTextField!
    @IBOutlet private weak var hourTextField: CustomTextField!
    @IBOutlet private weak var matchDateTextField: CustomTextField!
    @IBOutlet private weak var eventAreaTextField: CustomTextField!
    @IBOutlet private weak var firstTeamNameTextField: CustomTextField!
    @IBOutlet private weak var secondTeamNameTextField: CustomTextField!
    @IBOutlet private weak var hostIbanTextField: CustomTextField!
    @IBOutlet private weak var gameTypeTextField: CustomTextField!
    @IBOutlet private weak var hostNameTextField: CustomTextField!
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
        setupTimePicker()
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
        gameTypeTextField.inputView = pickerView
        cityTextField.inputAccessoryView = createToolbar()
        districtTextField.inputAccessoryView = createToolbar()
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

    private func setupTimePicker() {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.minuteInterval = 30
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        hourTextField.inputView = timePicker
        hourTextField.inputAccessoryView = createToolbar()
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
            "eventArea": eventAreaTextField,
            "firstTeamName": firstTeamNameTextField,
            "secondTeamName": secondTeamNameTextField,
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

    @objc private func timeChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        hourTextField.text = formatter.string(from: sender.date)
        viewModel.setField(field: .hour, value: hourTextField.text)
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
    
    // MARK: - ACTIONS

    @IBAction func createMatchButtonTapped(_ sender: UIButton) {
        if viewModel.validateFields() {
            saveToUserDefaults()
            let setTeamsVC: SetPlayersViewController = UIViewController.instantiate(from: .setPlayers)
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
        pickerView.selectRow(0, inComponent: 0, animated: false)
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
        case hostNameTextField, eventAreaTextField, firstTeamNameTextField, secondTeamNameTextField:
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

