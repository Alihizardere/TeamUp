//
//  PlayerCollectionViewCell.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 6.08.2024.
//

import UIKit

final class PlayerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlayerCollectionViewCell"
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblSurname: UILabel!
    
    @IBOutlet weak var view: UIView!
    
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
