//
//  FirebaseManager.swift
//  TeamUp
//
//  Created by alihizardere on 30.07.2024.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

protocol FirebaseServiceProtocol {
  func uploadPlayer(_ image: UIImage?, playerName: String?, playerSurname: String?,position: String?,overall: Int?, sportType: String, completion: @escaping (Result<Void, Error>) -> Void)
  func fetchPlayers(sportType: String, completion: @escaping ([Player]) -> Void)
  func updatePlayer(_ player: Player, sportType: String, completion: @escaping (Result<Void, Error>) -> Void)
  func deletePlayer(_ player: Player?, sportType: String, completion: @escaping (Result<Void,Error>)-> Void)
}


final class FirebaseService: FirebaseServiceProtocol {

  // MARK: - Properties
  private let databaseRef: DatabaseReference
  private let storageRef: StorageReference

  // MARK: - Init Method
   init() {
    self.databaseRef = Database.database().reference()
    self.storageRef = Storage.storage().reference()
  }

  func uploadPlayer(
    _ image: UIImage?,
    playerName: String?,
    playerSurname: String?,
    position: String?,
    overall: Int?,
    sportType: String,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }

    let playerID = databaseRef.child("players").child("\(sportType)_players").childByAutoId().key ?? UUID().uuidString
    let imageRef = storageRef.child("profile_images/\(playerID).jpg")

    imageRef.putData(imageData, metadata: nil) { metadata, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      imageRef.downloadURL { url, error in
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
        self.savePlayer(player, sportType: sportType)
        completion(.success(()))
      }
    }
  }

  func fetchPlayers(sportType: String, completion: @escaping ([Player]) -> Void) {
    databaseRef.child("players").child("\(sportType)_players").observe(.value) { snapshot in
      var players = [Player]()
      for child in snapshot.children {
        if let snapshot = child as? DataSnapshot,
           let dictionary = snapshot.value as? [String: Any] {
          let player = Player(
            id: snapshot.key,
            name: dictionary["name"] as? String,
            surname: dictionary["surname"] as? String,
            imageUrl: dictionary["imageUrl"] as? String,
            position: dictionary["position"] as? String,
            overall: dictionary["overall"] as? Int
          )
          players.append(player)
        }
      }
      completion(players)
    }
  }

  func updatePlayer(_ player: Player, sportType: String, completion: @escaping (Result<Void, Error>) -> Void){

    let playerData: [String: Any] = [
      "name": player.name ?? "",
      "surname": player.surname ?? "",
      "imageUrl": player.imageUrl ?? "",
      "position": player.position ?? "",
      "overall": player.overall ?? 0
    ]

    databaseRef.child("players").child("\(sportType)_players").child(player.id ?? "").updateChildValues(playerData) { error, _ in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(()))
      }
    }
  }

  func deletePlayer(_ player: Player?, sportType: String, completion: @escaping (Result<Void,Error>)-> Void){
    guard let player else { return }

    let playerRef = databaseRef.child("players").child("\(sportType)_players").child(player.id ?? "")

    if let imageUrl = player.imageUrl {
      let storageRef = Storage.storage().reference(forURL: imageUrl)
      storageRef.delete { error in
        if let error = error {
          completion(.failure(error))
        }
      }
      playerRef.removeValue { error, _ in
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.success(()))
        }
      }
    }
  }

  private func savePlayer(_ player: Player?, sportType: String) {
    guard let player else { return }

    let playerData: [String: Any] = [
      "name": player.name ?? "",
      "surname": player.surname ?? "",
      "imageUrl": player.imageUrl ?? "",
      "position": player.position ?? "",
      "overall": player.overall ?? 0
    ]
    databaseRef.child("players").child("\(sportType)_players").child(player.id ?? "").setValue(playerData)
  }
}

