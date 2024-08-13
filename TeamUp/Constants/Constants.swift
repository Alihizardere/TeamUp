//
//  Constants.swift
//  TeamUp
//
//  Created by alihizardere on 31.07.2024.
//

struct Constants {
    
    // MARK: - NETWORK
    
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather?"
    static let apiKey = "fe624ade820c8feeaf1bdee1b25eb45e"
    static let citiesURL = "https://turkiyeapi.dev/api/v1/provinces"
    
    // MARK: - SPORTS
    
    static let footballPositions = ["Goalkeeper", "Defenders", "Centre-back", "Right-back", "Left-back", " Midfielder", "Forwards", "Winger"]
    static let volleyballPositions = ["Setter", "Outside Hitter", "Middle Blocker", "Libero", "Opposite Hitter"]
    static let scores = ["70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99"]
    static let gameType = ["6x6","7x7","8x8","9x9","10x10"]
    
    enum SportType: String {
        case football
        case volleyball
        
        static let key = "sportType"
    }
}
