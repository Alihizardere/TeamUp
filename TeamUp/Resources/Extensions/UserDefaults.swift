//
//  UserDefaults.swift
//  TeamUp
//
//  Created by alihizardere on 10.08.2024.
//

import Foundation

extension UserDefaults {
    func set(_ value: Constants.SportType, forKey key: String) {
        self.set(value.rawValue, forKey: key)
    }

    func sportType(forKey key: String) -> Constants.SportType? {
        if let rawValue = self.string(forKey: key) {
            return Constants.SportType(rawValue: rawValue)
        }
        return nil
    }
}
