//
//  Router.swift
//  TeamUp
//
//  Created by alihizardere on 31.07.2024.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {

    case getWeatherCityName(city: String)
    case getCities
    case getDistricts(id: Int)

    // MARK: - method
    var method: HTTPMethod {
        switch self {
        case .getWeatherCityName, .getCities, .getDistricts:
            return  .get
        }
    }

    // MARK: - Parameters
    var parameters: [String: Any]? {
        switch self {
        case .getWeatherCityName, .getCities, .getDistricts:
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
        case .getWeatherCityName(let city):
            let urlString = "\(Constants.baseURL)q=\(city)&appid=\(Constants.apiKey)"
            guard let url = URL(string: urlString) else {
                fatalError("Invalid URL for city: \(city)")
            }
            return url

        case .getCities:
            guard let url = URL(string: Constants.citiesURL) else {
                fatalError("Invalid cities URL")
            }
            return url

        case .getDistricts(let id):
            let urlString = "\(Constants.citiesURL)/\(id)"
            guard let url = URL(string: urlString) else {
                fatalError("Invalid URL for district ID: \(id)")
            }
            return url
        }
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: parameters)
    }
}
