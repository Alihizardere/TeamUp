//
//  PlayerCollectionViewCell.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 6.08.2024.
//

import UIKit

final class PlayerCollectionViewCell: UICollectionViewCell {

    // MARK: - OUTLETS

    @IBOutlet private weak var lblName: UILabel!
    @IBOutlet private weak var lblSurname: UILabel!
    @IBOutlet private weak var view: UIView!

    // MARK: - PROPERTIES
    
    static let identifier = "PlayerCollectionViewCell"

    // MARK: - FUNCTIONS
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
    }
    
    func configure(with player:Player) {
        lblName.text = player.name
        lblSurname.text = player.surname
    }
}
