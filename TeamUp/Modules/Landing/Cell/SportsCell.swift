//
//  SportsCell.swift
//  TeamUp
//
//  Created by Ertuğrul Şahin on 13.08.2024.
//

import UIKit

final class SportsCell: UICollectionViewCell {

    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var view: UIView!
    static let identifier = "SportsCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        view.addShadow()
        sportImageView.layer.cornerRadius = 5
        sportImageView.layer.masksToBounds = true
    }

}
