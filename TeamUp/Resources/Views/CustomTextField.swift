//
//  CustomTextField.swift
//  TeamUp
//
//  Created by alihizardere on 11.08.2024.
//

import UIKit

class CustomTextField: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }
}
