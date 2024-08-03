//
//  LoadingShowable.swift
//  TeamUp
//
//  Created by alihizardere on 3.08.2024.
//

import UIKit

protocol LoadingShowable where Self: UIViewController {
  func showLoading()
  func hideLoading()
}

extension LoadingShowable {
  func showLoading() {
    LoadingView.shared.startLoading()
  }

  func hideLoading() {
    LoadingView.shared.hideLoading()
  }
}
