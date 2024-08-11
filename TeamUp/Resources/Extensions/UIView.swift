//
//  UIView.swift
//  TeamUp
//
//  Created by alihizardere on 5.08.2024.
//

import UIKit

extension UIView {
    func addShadow(color: UIColor = .label, opacity: Float = 0.3, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 2, cornerRadius: CGFloat = 5) {

    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offset
    layer.shadowRadius = radius
    layer.cornerRadius = cornerRadius
    layer.masksToBounds = false
  }
}
