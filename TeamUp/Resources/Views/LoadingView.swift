//
//  LoadingView.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 3.08.2024.
//

import UIKit

final class LoadingView {
    //MARK: - Properties
    static let shared = LoadingView()
    private var timer: Timer?
    private var minimumDuration: TimeInterval = 3.0
    private var blurView: UIVisualEffectView
    
    //MARK: - Init method
    private init() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = UIScreen.main.bounds
    }
    
    //MARK: - Functions
    func startLoading() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        if blurView.superview == nil {
            window.addSubview(blurView)
            
            NSLayoutConstraint.activate([
                blurView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                blurView.topAnchor.constraint(equalTo: window.topAnchor),
                blurView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
            ])
        }
    }
    
    func hideLoading() {
        blurView.removeFromSuperview()
    }
}
