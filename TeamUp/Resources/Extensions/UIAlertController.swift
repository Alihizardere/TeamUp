//
//  UIAlertController.swift
//  TeamUp
//
//  Created by alihizardere on 1.08.2024.
//

import UIKit

extension UIAlertController {
    static func showAlert(
        on viewController: UIViewController,
        title: String,
        message: String,
        primaryButtonTitle: String? = nil,
        primaryButtonStyle: UIAlertAction.Style = .default,
        primaryButtonHandler: (() -> Void)? = nil,
        secondaryButtonTitle: String? = nil,
        secondaryButtonStyle: UIAlertAction.Style = .cancel,
        secondaryButtonHandler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let primaryButtonTitle = primaryButtonTitle {
            let primaryAction = UIAlertAction(title: primaryButtonTitle, style: primaryButtonStyle) { _ in
                primaryButtonHandler?()
            }
            alert.addAction(primaryAction)
        }

        if let secondaryButtonTitle = secondaryButtonTitle {
            let secondaryAction = UIAlertAction(title: secondaryButtonTitle, style: secondaryButtonStyle) { _ in
                secondaryButtonHandler?()
            }
            alert.addAction(secondaryAction)
        }

        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
