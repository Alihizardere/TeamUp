//
//  LandingViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 29.07.2024.
//

import UIKit

final class LandingViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!

    let sports = ["footballIcon", "volleyballIcon", "basketballIcon", "tennisIcon"]

    
    
    // MARK: -  LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        print("This is landing page")
        if !Reachability.isConnectedToNetwork() {
            showAlertNoInternetConnection()
        }
        
        collectionView.register(UINib(nibName: SportsCell.identifier, bundle: nil), forCellWithReuseIdentifier: SportsCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (collectionView.frame.width / 2) - 15, height: (collectionView.frame.width / 2) - 15)

        collectionView.collectionViewLayout = layout
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - ACTIONS
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sports.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SportsCell.identifier, for: indexPath) as! SportsCell
        let sportName = sports[indexPath.item]
        cell.sportImageView.image = UIImage(named: sportName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected sport: \(sports[indexPath.item])")
    }
    
    
//    @IBAction func footballButtonTapped(_ sender: UIButton) {
//        handleSportSelection(.football)
//    }
//
//    @IBAction func volleyballButtonClicked(_ sender: UIButton) {
//        handleSportSelection(.volleyball)
//    }
    
    //MARK: -  PRIVATE FUNCTIONS

    private func checkInternetConnection() {
        if !Reachability.isConnectedToNetwork() {
            showAlertNoInternetConnection()
        }
    }

    private func handleSportSelection(_ sportType: Constants.SportType) {
        if Reachability.isConnectedToNetwork() {
            UserDefaults.standard.set(sportType, forKey: Constants.SportType.key)
            let homeVC: HomeViewController = UIViewController.instantiate(from: .home)
            navigationController?.pushViewController(homeVC, animated: true)
        } else {
            showAlertNoInternetConnection()
        }
    }
}
