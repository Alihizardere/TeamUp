//
//  EmptyView.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 3.08.2024.
//

import UIKit

extension UITableView {
  func setEmptyView(title: String, message: String, image: UIImage?) {
    let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let messageLabel = UILabel()

    imageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false

    imageView.image = image
    imageView.contentMode = .scaleAspectFit

    titleLabel.textColor = .black
    titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)

    messageLabel.textColor = .lightGray
    messageLabel.numberOfLines = 0
    messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)

    emptyView.addSubview(imageView)
    emptyView.addSubview(titleLabel)
    emptyView.addSubview(messageLabel)

    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -50),
      imageView.widthAnchor.constraint(equalToConstant: 150),
      imageView.heightAnchor.constraint(equalToConstant: 150),

      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
      titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),

      messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
    ])

    titleLabel.text = title
    messageLabel.text = message

    UIView.animate(withDuration: 0.25) {
      self.backgroundView = emptyView
    }
  }

  func restore() {
    UIView.animate(withDuration: 0.25) {
      self.backgroundView = nil
    }
  }
}

extension UICollectionView {
    func setEmptyView(title: String, message: String, image: UIImage?) {
      let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
      let imageView = UIImageView()
      let titleLabel = UILabel()
      let messageLabel = UILabel()

      imageView.translatesAutoresizingMaskIntoConstraints = false
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      messageLabel.translatesAutoresizingMaskIntoConstraints = false

      imageView.image = image
      imageView.contentMode = .scaleAspectFit

      titleLabel.textColor = .black
      titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)

      messageLabel.textColor = .lightGray
      messageLabel.numberOfLines = 0
      messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)

      emptyView.addSubview(imageView)
      emptyView.addSubview(titleLabel)
      emptyView.addSubview(messageLabel)

      NSLayoutConstraint.activate([
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
        imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -50),
        imageView.widthAnchor.constraint(equalToConstant: 150),
        imageView.heightAnchor.constraint(equalToConstant: 150),

        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),

        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
      ])

      titleLabel.text = title
      messageLabel.text = message

      UIView.animate(withDuration: 0.25) {
        self.backgroundView = emptyView
      }
    }

    func restore() {
      UIView.animate(withDuration: 0.25) {
        self.backgroundView = nil
      }
    }
  }
