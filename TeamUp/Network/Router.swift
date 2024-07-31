//
//  Router.swift
//  TeamUp
//
//  Created by alihizardere on 31.07.2024.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {

  case getWeather


  // MARK: - method
  var method: HTTPMethod {
    switch self {
    case .getWeather:
      return  .get
    }
  }
  // MARK: - Parameters
  var parameters: [String: Any]? {
    switch self {
    case .getWeather:
        return nil
    }
  }
  // MARK: - Encoding
  var encoding: ParameterEncoding {
    JSONEncoding.default
  }

  // MARK: - Url
  var url: URL {
    switch self {
    case .getWeather:
      let url = URL(string: Constants.weatherURL)
      return url!
    }
  }

  func asURLRequest() throws -> URLRequest {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    return try encoding.encode(urlRequest, with: parameters)
  }
}
