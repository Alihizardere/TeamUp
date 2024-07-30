//
//  Player.swift
//  TeamUp
//
//  Created by alihizardere on 30.07.2024.
//

import Foundation

struct Player: Decodable {
  let id: String?
  let name: String?
  let surname: String?
  let imageUrl: String?
  let position: String?
  let overall: Int?
}
