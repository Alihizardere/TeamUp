//
//  FirebaseManager.swift
//  TeamUp
//
//  Created by alihizardere on 30.07.2024.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

final class FirebaseService {

  // MARK: - Properties
  static let shared = FirebaseService()
  private let databaseRef: DatabaseReference
  private let storageRef: StorageReference

  // MARK: - Init Method
  private init() {
    self.databaseRef = Database.database().reference()
    self.storageRef = Storage.storage().reference()
  }

  // MARK: - Functions
  func fetchPlayerKeys(completion: @escaping ([String]) -> Void) {
    databaseRef.child("players").observeSingleEvent(of: .value) { snapshot in
      var keys = [String]()
      for child in snapshot.children {
        if let key = (child as? DataSnapshot)?.key {
          keys.append(key)
        }
      }
      completion(keys)
    }
  }

  func fetchPlayerData(forKey key: String, completion: @escaping (Player?) -> Void) {
    databaseRef.child("players").child(key).observeSingleEvent(of: .value) { snapshot in
      guard let dictionary = snapshot.value as? [String: Any] else {
        completion(nil)
        return
      }

      let player = Player(
        id: key,
        name: dictionary["name"] as? String,
        surname: dictionary["surname"] as? String,
        imageUrl: dictionary["imageUrl"] as? String,
        position: dictionary["position"] as? String,
        overall: dictionary["overall"] as? Int
      )
      completion(player)
    }
  }

  func uploadPlayerImage(
    _ image: UIImage?,
    playerName: String?,
    playerSurname: String?,
    position: String?,
    overall: Int?,
    completion: @escaping (Result<Player, Error>) -> Void
  ) {
    guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }

    let playerID = databaseRef.child("players").childByAutoId().key ?? UUID().uuidString
    let imageRef = storageRef.child("profile_images/\(playerID).jpg")

    imageRef.putData(imageData, metadata: nil) {
      metadata,
      error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      imageRef.downloadURL {
        url,
        error in
        if let error = error {
          completion(.failure(error))
          return
        }
        
        guard let downloadURL = url else { return }
        let player = Player(
          id: playerID,
          name: playerName,
          surname:playerSurname ,
          imageUrl: downloadURL.absoluteString,
          position: position,
          overall: overall
        )
        self.savePlayer(player)
        completion(.success(player))
      }
    }
  }

  private func savePlayer(_ player: Player?) {
    guard let player = player else { return }

    let playerData: [String: Any] = [
      "name": player.name ?? "",
      "surname": player.surname ?? "",
      "imageUrl": player.imageUrl ?? "",
      "position": player.position ?? "",
      "overall": player.overall ?? 0
    ]

    databaseRef.child("players").child(player.id ?? "").setValue(playerData)
  }
}
