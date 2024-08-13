//
//  ViewController.swift
//  TeamUp
//
//  Created by alihizardere on 29.07.2024.
//

import UIKit

class BaseViewController: UIViewController, LoadingShowable {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showAlertNoInternetConnection() {
        UIAlertController.showAlert(
            on: self,
            title: "No Internet Connection",
            message: "Please check your internet connection.",
            primaryButtonTitle: "OK",
            primaryButtonStyle: .default
        )
    }
}

