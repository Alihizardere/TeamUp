//
//  WeatherLogic.swift
//  TeamUp
//
//  Created by alihizardere on 31.07.2024.
//

import Foundation

protocol WeatherLogicProtocol {
  func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, Error>)-> Void)
}

final class WeatherLogic: WeatherLogicProtocol {

  static let shared: WeatherLogic = {
    let instance = WeatherLogic()
    return instance
  }()

  private init() {}

  func fetchWeather(
    latitude: Double,
    longitude: Double,
    completion: @escaping (Result<WeatherResponse, any Error>) -> Void
  ) {
    Webservice.shared.request(
      request: Router.getWeather(latitude: latitude, longitude: longitude),
      decodeType: WeatherResponse.self,
      completionHandler: completion
    )
  }

}
