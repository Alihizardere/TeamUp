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
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var matchDateTextField: UITextField!
    @IBOutlet weak var hostIbanTextField: UITextField!
    @IBOutlet weak var gameTypeTextField: UITextField!
    
    //MARK: - Properties
    var activeTextField: UITextField?
    private let locationManager = CLLocationManager()
    private let pickerView = UIPickerView()
    private let datePicker = UIDatePicker()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        setupDatePicker()
        loadUserDefaults()
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
            "groupName": groupNameTextField,
            "location": locationTextField,
            "hour": hourTextField,
            "matchDate": matchDateTextField,
            "hostIban": hostIbanTextField,
            "gameType": gameTypeTextField
        ]
        
        for(key, textfield) in textFieldDictionary {
            defaults.set(textfield.text, forKey: key)
        }
    }
    
    private func loadUserDefaults() {
        let defaults = UserDefaults.standard
        let textFieldDictionary: [String: UITextField] = [
            "groupName": groupNameTextField,
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
            groupNameTextField,
            locationTextField,
            hourTextField,
            matchDateTextField,
            hostIbanTextField,
            gameTypeTextField
        ]
        
        for textField in textFields {
            if textField.text?.isEmpty ?? true {
                return false
            }
        }
        
        return true
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
    
    @objc private func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        matchDateTextField.text = formatter.string(from: datePicker.date)
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
extension CreateMatchViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
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
    }
}

//MARK: - UITextFieldDelegate
extension CreateMatchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        pickerView.reloadAllComponents()
    }
}
