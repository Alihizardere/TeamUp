//
//  PlayerCollectionViewCell.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 5.08.2024.
//

import UIKit

final class PlayerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlayerCollectionViewCell"

    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var lblPlayerSurname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with player: Player) {
        lblPlayerName.text = player.name
        lblPlayerSurname.text = player.surname
    }
}
