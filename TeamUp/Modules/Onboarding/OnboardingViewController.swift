//
//  OnboardingViewController.swift
//  TeamUp
//
//  Created by alihizardere on 9.08.2024.
//

import UIKit

final class OnboardingViewController: UIViewController {

  // MARK: - OUTLETS

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var nextLabel: UIButton!
  @IBOutlet weak var pageControl: UIPageControl!

  // MARK: - PROPERTIES
  var slides = [OnboardingSlide]()
  var currentPage = 0 {
    didSet{
      pageControl.currentPage = currentPage
      if currentPage == slides.count - 1 {
        nextLabel.setTitle("LET'S GET STARTED", for: .normal)
      }else{
        nextLabel.setTitle("NEXT", for: .normal)
      }
    }
  }

  // MARK: - LIFE CYCLE
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(
      UINib(nibName: OnboardingCell.identifier, bundle: nil),
      forCellWithReuseIdentifier:  OnboardingCell.identifier
    )
    slides = OnboardingMockData.getSlides()
  }

  // MARK: - ACTIONS

  @IBAction func nextButton(_ sender: UIButton) {
    if currentPage == slides.count - 1 {
      let landingVC = LandingViewController(nibName: "LandingViewController", bundle: nil)
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
    return slides.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let slide = slides[indexPath.row]
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: OnboardingCell.identifier,
      for: indexPath
    ) as? OnboardingCell else { return UICollectionViewCell() }
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
