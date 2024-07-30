//
//  PlayerCell.swift
//  TeamUp
//
//  Created by alihizardere on 30.07.2024.
//

import UIKit
import Kingfisher

class PlayerCell: UITableViewCell {

  // MARK: - Properties
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var surnameLabel: UILabel!
  @IBOutlet weak var positionLabel: UILabel!
  @IBOutlet weak var overallLabel: UILabel!
  static let identifier = "PlayerCell"

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

  func configure(with player: Player) {
    nameLabel.text = player.name
    surnameLabel.text = player.surname
    positionLabel.text = player.position
    overallLabel.text = "\( player.overall ?? 0)"
    if let imageUrlString = player.imageUrl, let imageUrl = URL(string: imageUrlString) {
      profileImage.kf.setImage(with: imageUrl)
    } else {
      profileImage.image = UIImage(named: "placeholder")
    }
  }

}
