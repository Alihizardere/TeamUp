//
//  MatchDetailViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 31.07.2024.
//

import UIKit

final class MatchDetailViewController: BaseViewController {

    // MARK: - OUTLETS

    @IBOutlet private weak var firstTeamNameLabel: UILabel!
    @IBOutlet private weak var secondTeamNameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var disctrictLabel: UILabel!
    @IBOutlet private weak var eventAreaLabel: UILabel!
    @IBOutlet private weak var hourLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var temperatureDescriptionLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var showAllPlayersLabel: UILabel!
    @IBOutlet private weak var backToHomeButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var hostIbanLabel: UILabel!
    @IBOutlet private weak var hostNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var weatherView: UIView!
    @IBOutlet private weak var nextMatchView: UIView!
    @IBOutlet private weak var hostView: UIView!
    @IBOutlet private weak var playersView: UIView!
    @IBOutlet private weak var teamSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var sportsFieldImage: UIImageView!
    @IBOutlet private weak var firstTeamView: UIView!
    @IBOutlet private weak var secondTeamView: UIView!
    

    // MARK: - PROPERTIES

    private let defaults = UserDefaults.standard
    private var panGestureRecognizers: [UIPanGestureRecognizer] = []
    var team1Players: [Player] = []
    var team2Players: [Player] = []
    private var viewModel: MatchDetailViewModelProtocol = MatchDetailViewModel()

    // MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - PRIVATE FUNCTIONS

    private func addShadowToView() {
        [nextMatchView, weatherView, playersView, hostView].forEach { $0.addShadow() }
    }

    private func loadUserDefaults() {
        locationLabel.text = defaults.string(forKey: "city") ?? "N/A"
        disctrictLabel.text = defaults.string(forKey: "district") ?? "N/A"
        eventAreaLabel.text = defaults.string(forKey: "eventArea") ?? "N/A"
        hourLabel.text = defaults.string(forKey: "hour") ?? "N/A"
        firstTeamNameLabel.text = defaults.string(forKey: "firstTeamName") ?? "N/A"
        secondTeamNameLabel.text = defaults.string(forKey: "secondTeamName") ?? "N/A"
        dateLabel.text = defaults.string(forKey: "matchDate") ?? "N/A"
        hostIbanLabel.text = "TR\(defaults.string(forKey: "hostIban") ?? "N/A")"
        hostNameLabel.text = defaults.string(forKey: "hostName") ?? "N/A"
        if let pricePerPlayer = viewModel.calculatePricePerPlayer() {
            priceLabel.text = "\(pricePerPlayer)₺"
        } else {
            priceLabel.text = "N/A"
        }
    }

    private func updateWeatherImage(for weather: Weather) { // Switch yapısı viewModel'a taşınabilir
        switch weather.main?.lowercased() {
        case "rain":
            weatherImage.image = UIImage(systemName: "cloud.rain")
        case "clear":
            weatherImage.image = UIImage(systemName: "sun.min.fill")
            weatherImage.tintColor = .systemYellow
        case "clouds":
            weatherImage.image = UIImage(systemName: "cloud.fill")
            weatherImage.tintColor = .systemGray3
        default:
            weatherImage.image = UIImage(systemName: "questionmark.circle")
        }
    }

    private func setupSportsFieldImage() {
        if let sportType = UserDefaults.standard.sportType(forKey: Constants.SportType.key) {
            switch sportType {
            case .football:
                sportsFieldImage.image = UIImage(named: "footballField")
            case .volleyball:
                sportsFieldImage.image = UIImage(named: "volleyball")
            case .basketball:
                sportsFieldImage.image = UIImage(named: "basketballField")
            case .tennis:
                sportsFieldImage.image = UIImage(named: "tennisCourt")
            }
        }
    }

    private func setupCornerRadius(for views: [UIView], radius: CGFloat) {
        views.forEach { view in
            view.layer.cornerRadius = radius
            view.layer.masksToBounds = true
        }
    }

    private func setupShowAllPlayersTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAllPlayersTapped))
        showAllPlayersLabel.isUserInteractionEnabled = true
        showAllPlayersLabel.addGestureRecognizer(tapGesture)
    }

    private func setupDraggableViews(for team: [Player], in teamView: UIView) {
        teamView.subviews.forEach { $0.removeFromSuperview() }

        var teamDraggableViews: [PlayerCustomView] = []

        team.forEach { player in
            let view = PlayerCustomView(
                name: player.name ?? "Unknown",
                imageName: "teamUp",
                overallScore: String(player.overall ?? 70)
            )
            view.tag = player.id.hashValue
            teamDraggableViews.append(view)
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            view.addGestureRecognizer(panGestureRecognizer)
            view.isUserInteractionEnabled = true
            teamView.addSubview(view)
        }
        layoutDraggableViews(teamDraggableViews, in: teamView, for: team)
    }

    private func layoutDraggableViews(_ draggableViews: [PlayerCustomView], in teamView: UIView, for team: [Player]) {
        let viewSize: CGFloat = 80
        let spacing: CGFloat = 30

        var remainingPlayers = draggableViews
        if let goalkeeperIndex = team.firstIndex(where: { $0.position == "Goalkeeper" }) {
            let goalkeeperView = draggableViews[goalkeeperIndex]
            remainingPlayers.remove(at: goalkeeperIndex)
            layoutGoalkeeper(goalkeeperView, size: viewSize, in: teamView)
        }
        layoutRemainingPlayers(remainingPlayers, size: viewSize, spacing: spacing, in: teamView)
    }

    private func layoutGoalkeeper(_ view: UIView, size: CGFloat, in teamView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: size),
            view.heightAnchor.constraint(equalToConstant: size),
            view.centerXAnchor.constraint(equalTo: teamView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: teamView.bottomAnchor, constant: -teamView.frame.height / 6)
        ])
    }

    private func layoutRemainingPlayers(_ views: [UIView], size: CGFloat, spacing: CGFloat, in teamView: UIView) {
        let rows = 3
        let columns = (views.count + rows - 1) / rows

        for (index, view) in views.enumerated() {
            let row = index / columns
            let column = index % columns

            let xOffset = CGFloat(column) * (size + spacing) - CGFloat(columns - 1) * (size + spacing) / 2
            let yOffset = CGFloat(row) * (size + spacing) - CGFloat(rows - 1) * (size + spacing) / 2

            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: size),
                view.heightAnchor.constraint(equalToConstant: size),
                view.centerXAnchor.constraint(equalTo: teamView.centerXAnchor, constant: xOffset),
                view.centerYAnchor.constraint(equalTo: teamView.centerYAnchor, constant: -yOffset * 1.1)
            ])
        }
    }

    private func changeTeam() {
        firstTeamView.isHidden = teamSegmentedControl.selectedSegmentIndex != 0
        secondTeamView.isHidden = teamSegmentedControl.selectedSegmentIndex == 0
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let draggedView = gesture.view, let superview = draggedView.superview else { return }
        let translation = gesture.translation(in: view)

        if gesture.state == .began || gesture.state == .changed {
            let newCenter = CGPoint(x: draggedView.center.x + translation.x, y: draggedView.center.y + translation.y)
            let minX = draggedView.bounds.width / 2
            let maxX = superview.bounds.width - minX
            let minY = draggedView.bounds.height / 2
            let maxY = superview.bounds.height - minY

            draggedView.center = CGPoint(
                x: min(max(newCenter.x, minX), maxX),
                y: min(max(newCenter.y, minY), maxY)
            )

            gesture.setTranslation(.zero, in: view)

        } else if gesture.state == .ended {

            let existingConstraints = draggedView.constraints.filter({ $0.identifier == "centerX" || $0.identifier == "centerY" })
            NSLayoutConstraint.deactivate(existingConstraints)

            let centerXConstraint = draggedView.centerXAnchor.constraint(equalTo: superview.leadingAnchor, constant: draggedView.center.x)
            centerXConstraint.identifier = "centerX"
            let centerYConstraint = draggedView.centerYAnchor.constraint(equalTo: superview.topAnchor, constant: draggedView.center.y)
            centerYConstraint.identifier = "centerY"

            NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
        }
    }

    @objc private func showAllPlayersTapped() {
        let playerListVC: PlayerListViewController = UIViewController.instantiate(from: .playerList)
        navigationController?.pushViewController(playerListVC, animated: true)
    }

    @IBAction func teamSegmentedControlTapped(_ sender: UISegmentedControl) {
        changeTeam()
    }

    @IBAction func backToLandingButtonTapped(_ sender: UIButton) {
        let landingVC: LandingViewController = UIViewController.instantiate(from: .landing)
        navigationController?.pushViewController(landingVC, animated: false)
    }

    @IBAction func shareButtonTapped(_ sender: UIButton) {
        let hostName = defaults.string(forKey: "hostName") ?? "N/A"
        let matchDate = defaults.string(forKey: "matchDate") ?? "N/A"
        let matchHour = defaults.string(forKey: "hour") ?? "N/A"
        let matchLocation = defaults.string(forKey: "city") ?? "N/A"
        let matchDistrict = defaults.string(forKey: "district") ?? "N/A"
        let matchArea = defaults.string(forKey: "eventArea") ?? "N/A"
        let hostIban = defaults.string(forKey: "hostIban") ?? "N/A"

        let matchInfo = """
            Host Name: \(hostName)
            HostIban: \(hostIban)
            Match Date: \(matchDate)
            Match Hour: \(matchHour)
            Location: \(matchLocation)
            District: \(matchDistrict)
            Area: \(matchArea)
            """
        let activityViewController = UIActivityViewController(activityItems: [matchInfo], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - MatchDetailViewModelDelegate

extension MatchDetailViewController: MatchDetailViewModelDelegate {

    func setupUI() {
        viewModel.loadPlayers()
        setupDraggableViews(for: team1Players, in: firstTeamView)
        setupDraggableViews(for: team2Players, in: secondTeamView)
        addShadowToView()
        loadUserDefaults()
        setupSportsFieldImage()
        setupCornerRadius(for: [weatherView, nextMatchView, hostView, playersView], radius: 10)
        setupShowAllPlayersTapGesture()
        changeTeam()
        shareButton.setTitle("", for: .normal)
        backToHomeButton.setTitle("", for: .normal)
        if let city = defaults.string(forKey: "city") {
            viewModel.getWeather(for: city)
        }
    }

    func configurePlayerData(players: [Player]) {
        setupDraggableViews(for: players, in: firstTeamView)
        setupDraggableViews(for: players, in: secondTeamView)
    }

    func configureWeatherResponse(weatherResponse: WeatherResponse) {
        if let tempInFahrenheit = weatherResponse.main?.temp {
            let tempInCelsius = tempInFahrenheit - 273.15
            temperatureLabel.text = "\(Int(tempInCelsius))°C"
        }
        if let wind = weatherResponse.wind {
            windLabel.text = "\(Int(wind.speed ?? 700)) km/s"
        }
        if let weather = weatherResponse.weather?.first {
            temperatureDescriptionLabel.text = weather.description?.capitalized
            updateWeatherImage(for: weather)
        }
    }
}
