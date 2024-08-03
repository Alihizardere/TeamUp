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
    
    //MARK: - Properties
    var activeTextField: UITextField?
    private let locationManager = CLLocationManager()
    private let pickerView = UIPickerView()
    private let datePicker = UIDatePicker()
    private let ibanPrefix = String(repeating: " ", count: 1)
    private let ibanMaxLength = 32
    private let pasteButton = UIButton(type: .system)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        setupDatePicker()
        setupTextFields()
        loadUserDefaults()
        updateCreateButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Private Functions
    
    private func setupPickerView() {
        hourTextField.inputView = pickerView
        gameTypeTextField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        
        hourTextField.delegate = self
        gameTypeTextField.delegate = self
    }
    
    private func saveToUserDefaults() {
        let defaults = UserDefaults.standard
        let textFieldDictionary: [String: UITextField] = [
            "location": locationTextField,
            "hour": hourTextField,
            "matchDate": matchDateTextField,
            "hostIban": hostIbanTextField,
            "gameType": gameTypeTextField
        ]
        
        for (key, textfield) in textFieldDictionary {
            defaults.set(textfield.text, forKey: key)
        }
    }
    
    private func loadUserDefaults() {
        let defaults = UserDefaults.standard
        let textFieldDictionary: [String: UITextField] = [
            "location": locationTextField,
            "hour": hourTextField,
            "matchDate": matchDateTextField,
            "hostIban": hostIbanTextField,
            "gameType": gameTypeTextField
        ]
        
        for (key, textField) in textFieldDictionary {
            textField.text = defaults.string(forKey: key)
        }
    }
    
    private func validateTextFields() -> Bool {
        let textFields: [UITextField] = [
            locationTextField,
            hourTextField,
            matchDateTextField,
            hostIbanTextField,
            hostNameTextField,
            gameTypeTextField
        ]
        
        var allValid = true
        for textField in textFields {
            if textField.text?.isEmpty ?? true {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 0.5
                textField.layer.cornerRadius = 6.0
                allValid = false
            } else {
                textField.layer.borderColor = UIColor.clear.cgColor
                textField.layer.borderWidth = 0.0
                textField.layer.cornerRadius = 6.0
            }
        }
        return allValid
    }
    
    private func setupTextFields() {
        
        pasteButton.setImage(UIImage(systemName: "doc.on.clipboard"), for: .normal)
        pasteButton.tintColor = .systemGray
        pasteButton.addTarget(self, action: #selector(pasteIban), for: .touchUpInside)
        
        hostIbanTextField.rightView = pasteButton
        hostIbanTextField.rightViewMode = .always
    }
    
    private func setupDatePicker() {
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        matchDateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    private func updateCreateButtonState() {
        createMatchButton.isEnabled = validateTextFields()
    }
    
    
    @objc private func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        matchDateTextField.text = formatter.string(from: datePicker.date)
    }
    
    @objc private func pasteIban() {
            if let pasteString = UIPasteboard.general.string {
                hostIbanTextField.text = pasteString
            }
        }
    
  
 
    
    //MARK: - Button Actions
    @IBAction func createMatchButtonTapped(_ sender: Any) {
        if validateTextFields() {
            saveToUserDefaults()
            let matchDetailVC = MatchDetailViewController(nibName: "MatchDetailViewController", bundle: nil)
            navigationController?.pushViewController(matchDetailVC, animated: true)
        } else {
            UIAlertController.showAlert(on: self, title: "Eksik Bilgi", message: "Lütfen tüm alanları doldurun", primaryButtonTitle: "Tamam")
        }
    }
}

//MARK: - Extension UIPickerViewDelegate && UIPickerViewDataSource
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
            hourTextField.text = Constants.hours[row]
        case gameTypeTextField:
            gameTypeTextField.text = Constants.gameType[row]
        default:
            break
        }
        activeTextField?.resignFirstResponder()
        updateCreateButtonState()
    }
}

//MARK: - UITextFieldDelegate
extension CreateMatchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        pickerView.reloadAllComponents()
        
        if textField == hostIbanTextField {
            textField.text = ibanPrefix
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == hostIbanTextField else { return true }
        
        let newLength = (textField.text?.count ?? 0) + string.count - range.length
        if range.location < ibanPrefix.count {
            return false
        }
        return newLength <= ibanMaxLength
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateCreateButtonState()
    }
}
