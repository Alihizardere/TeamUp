//
//  OnboardingViewController.swift
//  TeamUp
//
//  Created by alihizardere on 9.08.2024.
//

import UIKit

final class OnboardingViewController: UIViewController {

    // MARK: - OUTLETS

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nextLabel: UIButton!
    @IBOutlet private weak var pageControl: UIPageControl!

    // MARK: - PROPERTIES

    private var viewModel: OnboardingViewModelProtocol! {
        didSet { viewModel.delegate = self }
    }
    private var currentPage = 0 {
        didSet{
            pageControl.currentPage = currentPage
            if currentPage == viewModel.slides.count - 1 {
                nextLabel.setTitle("LET'S GET STARTED", for: .normal)
            } else {
                nextLabel.setTitle("NEXT", for: .normal)
            }
        }
    }

    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OnboardingViewModel()
        viewModel.viewDidLoad()
    }

    // MARK: - ACTIONS

    @IBAction func nextButton(_ sender: UIButton) {
        if currentPage == viewModel.slides.count - 1 {
            let landingVC: LandingViewController = UIViewController.instantiate(from: .landing)
            navigationController?.pushViewController(landingVC, animated: true)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - CollectionViewDelegate

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.slides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingCell.identifier,
            for: indexPath
        ) as? OnboardingCell else { return UICollectionViewCell() }
        let slide = viewModel.slides[indexPath.row]
        cell.setup(slide)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
    }
}

// MARK: - OnboardingViewModelDelegate

extension OnboardingViewController: OnboardingViewModelDelegate {
    func setupUI() {
        collectionView.register(
            UINib(nibName: OnboardingCell.identifier, bundle: nil),
            forCellWithReuseIdentifier:  OnboardingCell.identifier
        )
    }
}
