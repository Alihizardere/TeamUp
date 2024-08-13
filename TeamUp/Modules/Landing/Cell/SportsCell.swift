//
//  SportsCell.swift
//  TeamUp
//
//  Created by Ertuğrul Şahin on 13.08.2024.
//

import UIKit

final class SportsCell: UICollectionViewCell {

    @IBOutlet weak var sportImageView: UIImageView!
    static let identifier = "SportsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sportImageView.layer.cornerRadius = 15
    }

}
