//
//  WeatherResponse.swift
//  TeamUp
//
//  Created by alihizardere on 31.07.2024.
//

// MARK: - WeatherResponse

struct WeatherResponse: Decodable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Clouds

struct Clouds: Decodable {
    let all: Int?
}

// MARK: - Coord

struct Coord: Decodable {
    let lon, lat: Double?
}

// MARK: - Main

struct Main: Decodable{
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?
}

// MARK: - Sys

struct Sys: Decodable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather

struct Weather: Decodable {
    let id: Int?
    let main, description, icon: String?
}

// MARK: - Wind

struct Wind: Decodable {
    let speed: Double?
    let deg: Int?
}
