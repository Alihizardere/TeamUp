//
//  LandingViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 29.07.2024.
//

import UIKit

final class LandingViewController: BaseViewController {

    // MARK: - OUTLETS

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - PROPERTIES

    private var viewModel: LandingViewModelProtocol! {
        didSet { viewModel.delegate = self }
    }

    // MARK: -  LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LandingViewModel()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - UICollectionViewDelegate && UICollectionViewDataSource

extension LandingViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sports.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SportsCell.identifier,
            for: indexPath
        ) as? SportsCell else { return UICollectionViewCell() }
        let sportName = viewModel.sports[indexPath.item]
        cell.sportImageView.image = UIImage(named: sportName)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectSport(at: indexPath.item)
    }
}

// MARK: - LandingViewModelDelegate

extension LandingViewController: LandingViewModelDelegate {
    
    func setupUI() {
        if !Reachability.isConnectedToNetwork() {
            showAlertNoInternetConnection()
        }

        collectionView.register(
            UINib(nibName: SportsCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: SportsCell.identifier
        )
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(
            width: (collectionView.frame.width / 2) - 15,
            height: (collectionView.frame.height / 2) - 15
        )
        collectionView.collectionViewLayout = layout
    }

    func handleSportSelection(sportType: Constants.SportType) {
        if Reachability.isConnectedToNetwork() {
            UserDefaults.standard.set(sportType, forKey: Constants.SportType.key)
            let homeVC: HomeViewController = UIViewController.instantiate(from: .home)
            navigationController?.pushViewController(homeVC, animated: true)
        } else {
            showAlertNoInternetConnection()
        }
    }
}
