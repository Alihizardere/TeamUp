//
//  WeatherLogic.swift
//  TeamUp
//
//  Created by alihizardere on 31.07.2024.
//

import Foundation

protocol WeatherLogicProtocol {
  func fetchWeatherCityName(city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
  func fetchCities(completion: @escaping (Result<CityResponse,Error>) -> Void)
  func fetchDistricts(id: Int, completion: @escaping (Result<DistrictResponse,Error>) -> Void)

}

final class WeatherLogic: WeatherLogicProtocol {

  static let shared: WeatherLogic = {
    let instance = WeatherLogic()
    return instance
  }()

  private init() {}

  func fetchWeatherCityName(city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
    Webservice.shared.request(
      request: Router.getWeatherCityName(city: city),
      decodeType: WeatherResponse.self,
      completionHandler: completion
    )
  }

  func fetchCities(completion: @escaping (Result<CityResponse, any Error>) -> Void) {
    Webservice.shared.request(
      request: Router.getCities,
      decodeType: CityResponse.self,
      completionHandler: completion
    )
  }
  
  func fetchDistricts(id: Int, completion: @escaping (Result<DistrictResponse, any Error>) -> Void) {
    Webservice.shared.request(
      request: Router.getDistricts(id: id),
      decodeType: DistrictResponse.self,
      completionHandler: completion
    )
  }

}
