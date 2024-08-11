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
      OnboardingSlide(title: "Build Your Team", description: "Select your team, arrange players on the field, and craft the perfect lineup. Customize your strategy and watch your team come together!", animationName: "Animation1"),
      OnboardingSlide(title: "Explore Player Details", description: "Tap on any player to view their stats, position, and key details. Get to know each player's strengths and plan your team more effectively!", animationName: "Animation2"),
      OnboardingSlide(title: "Plan and Win Matches", description: "Develop strategies, and lead your team to victory. Step onto the field with the right tactics and savor success..", animationName: "Animation3")
    ]
  }
}
