//
//  SportsCell.swift
//  TeamUp
//
//  Created by Ertuğrul Şahin on 13.08.2024.
//

import UIKit

final class SportsCell: UICollectionViewCell {

    // MARK: - OUTLETS

    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var view: UIView!

    // MARK: -  PROPERTIES

    static let identifier = "SportsCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        view.addShadow()
        sportImageView.layer.cornerRadius = 5
        sportImageView.layer.masksToBounds = true
    }
}
