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
    
    private func setupDatePicker() {
            datePicker.datePickerMode = .date
            matchDateTextField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        }
        
        @objc private func dateChanged() {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            matchDateTextField.text = formatter.string(from: datePicker.date)
        }
    
    private func showErrorAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    
    //MARK: - Button Actions
    @IBAction func createMatchButtonTapped(_ sender: Any) {
        let matchDetailVC = MatchDetailViewController(nibName: "MatchDetailViewController", bundle: nil)
        navigationController?.pushViewController(matchDetailVC, animated: true)
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
