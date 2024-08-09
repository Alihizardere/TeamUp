//
//  OnboardingSlide.swift
//  TeamUp
//
//  Created by alihizardere on 9.08.2024.
//

struct OnboardingSlide {
  let title: String
  let description: String
  let animationName: String
}

struct OnboardingMockData {
  static func getSlides() -> [OnboardingSlide] {
    return [
      OnboardingSlide(title: "Build Your Team and Hit the Field", description: "Choose your football or volleyball team and get ready to hit the field! Drag and drop your players into any position and create the perfect lineup.", animationName: "Animation1"),
      OnboardingSlide(title: "Explore Player Details", description: "Dive deep into the skills of each team member. Develop your players and gain a strategic edge over your opponents.", animationName: "Animation2"),
      OnboardingSlide(title: "Plan and Win Matches", description: "Create your own matches and develop strategies that will lead your team to victory. Step onto the field with the right tactics and savor the taste of success.", animationName: "Animation3")
    ]
  }
}
