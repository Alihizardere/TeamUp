//
//  CityResponse.swift
//  TeamUp
//
//  Created by alihizardere on 9.08.2024.
//

// MARK: - CityResponse

struct CityResponse: Decodable {
    let data: [City]?
}

// MARK: - DistrictResponse
struct DistrictResponse: Decodable {
  let data: City?
}

// MARK: - City

struct City: Decodable {
    let id: Int?
    let name: String?
    let districts: [District]?
}

// MARK: - District

struct District: Decodable {
    let id: Int?
    let name: String?
    let population, area: Int?
}
