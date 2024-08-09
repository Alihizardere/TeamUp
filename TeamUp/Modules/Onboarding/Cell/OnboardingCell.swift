//
//  OnboardingCell.swift
//  TeamUp
//
//  Created by alihizardere on 9.08.2024.
//

import UIKit
import Lottie

final class OnboardingCell: UICollectionViewCell {

  // MARK: - OUTLETS
  @IBOutlet weak var animationView: LottieAnimationView!
  @IBOutlet weak var slideTitle: UILabel!
  @IBOutlet weak var slideDescription: UILabel!

  // MARK: - PROPERTIES

  static let identifier = "OnboardingCell"

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func setup(_ slide: OnboardingSlide){
      slideTitle.text = slide.title
      slideDescription.text = slide.description
      playAnimation(named: slide.animationName)
  }

  private func playAnimation(named animationName: String) {
    let animation = LottieAnimationView.init(name: animationName)
    animationView.animation = animation.animation
    animationView.contentMode = .center
    animationView.loopMode = .loop
    animationView.animationSpeed = 0.5
    animationView.play()
  }
}
