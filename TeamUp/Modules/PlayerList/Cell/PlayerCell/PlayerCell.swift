//
//  PlayerCell.swift
//  TeamUp
//
//  Created by alihizardere on 30.07.2024.
//

import UIKit
import Kingfisher

class PlayerCell: UITableViewCell {
    
    // MARK: - PROPERTIES

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var overallLabel: UILabel!
    static let identifier = "PlayerCell"
    
    // MARK: -  FUNCTIONS

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addShadow(cornerRadius: 15)
        sideView.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with player: Player, index: IndexPath) {
        nameLabel.text = player.name
        surnameLabel.text = player.surname
        positionLabel.text = player.position
        overallLabel.text = "\( player.overall ?? 0)"
        if let imageUrlString = player.imageUrl, let imageUrl = URL(string: imageUrlString) {
            profileImage.kf.setImage(with: imageUrl)
        } else {
            profileImage.image = UIImage(named: "placeholder")
        }
        
        let colors: [UIColor] = [.first, .second, .third, .fourth]
        let colorsReversed: [UIColor] = colors.reversed()
        let colorGroupSize = 2
        let colorIndex = (index.row / colorGroupSize) % colors.count
        sideView.backgroundColor = colors[colorIndex]
        profileImage.layer.borderColor = colorsReversed[colorIndex].cgColor
        profileImage.layer.borderWidth = 3
    }
}
