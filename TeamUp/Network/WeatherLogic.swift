//
//  WeatherLogic.swift
//  TeamUp
//
//  Created by alihizardere on 31.07.2024.
//

import Foundation

protocol WeatherLogicProtocol {

}

final class WeatherLogic: WeatherLogicProtocol {

  static let shared: WeatherLogic = {
    let instance = WeatherLogic()
    return instance
  }()

  private init() {}

}
