//
//  PlayerCustomView.swift
//  TeamUp
//
//  Created by alihizardere on 6.08.2024.
//

import UIKit

final class PlayerCustomView: UIView {

    // MARK: - PROPERTIES

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let overallScoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .black
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - INIT

    init(name: String, imageName: String, overallScore: String) {
        super.init(frame: .zero)
        setupView(name: name, imageName: imageName, overallScore: overallScore)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - PRIVATE FUNCTIONS

    private func setupView(name: String, imageName: String, overallScore: String) {
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false

        imageView.image = UIImage(named: imageName)
        label.text = name
        overallScoreLabel.text = overallScore

        imageView.addSubview(overallScoreLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        self.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.7),

            overallScoreLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 2),
            overallScoreLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -2),
            overallScoreLabel.widthAnchor.constraint(equalToConstant: 20),
            overallScoreLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
