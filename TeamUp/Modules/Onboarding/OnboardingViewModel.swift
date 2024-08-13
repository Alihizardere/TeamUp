//
//  OnboardingViewModel.swift
//  TeamUp
//
//  Created by alihizardere on 13.08.2024.
//

// MARK: - OnboardingViewModelDelegates

protocol OnboardingViewModelDelegate: AnyObject {
    func setupUI()
}

protocol OnboardingViewModelProtocol {
    var delegate: OnboardingViewModelDelegate? { get set }
    var slides: [OnboardingSlide] { get }
    func viewDidLoad()
}

// MARK: -  OnboardingViewModel

final class OnboardingViewModel {
    weak var delegate:  OnboardingViewModelDelegate?
    var slides: [OnboardingSlide] = OnboardingMockData.getSlides()
}

// MARK: - OnboardingViewModelProtocols

extension OnboardingViewModel: OnboardingViewModelProtocol {
    func viewDidLoad() {
        self.delegate?.setupUI()
    }
}
