//
//  MatchDetailViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 31.07.2024.
//

import UIKit
import CoreLocation

final class MatchDetailViewController: BaseViewController {

    //MARK: - OUTLETS
    @IBOutlet private weak var lblLocation: UILabel!
    @IBOutlet private weak var lblHour: UILabel!
    @IBOutlet private weak var lblTemp: UILabel!
    @IBOutlet private weak var lblTempDesc: UILabel!
    @IBOutlet private weak var lblWind: UILabel!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var lblNumberOfPlayers: UILabel!
    @IBOutlet private weak var lblShowAllPlayers: UILabel!
    @IBOutlet private weak var lblHostIban: UILabel!
    @IBOutlet private weak var lblHostName: UILabel!
    @IBOutlet private weak var weatherView: UIView!
    @IBOutlet private weak var nextMatchView: UIView!
    @IBOutlet private weak var hostView: UIView!
    @IBOutlet private weak var playersView: UIView!
    @IBOutlet private weak var teamSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var firstTeamView: UIView!
    @IBOutlet private weak var secondTeamView: UIView!

    //MARK: - PROPERTIES

    private let locationManager = CLLocationManager()
    private var panGestureRecognizers: [UIPanGestureRecognizer] = []
    private var viewModel: MatchDetailViewModelProtocol! {
      didSet { viewModel.delegate = self}
    }

    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MatchDetailViewModel()
        viewModel.viewDidLoad()
    }

    //MARK: - PRIVATE FUNCTIONS

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    private func loadUserDefaults() {
        let defaults = UserDefaults.standard
        lblHour.text = defaults.string(forKey: "hour") ?? "N/A"
        lblDate.text = defaults.string(forKey: "matchDate") ?? "N/A"
        lblHostIban.text = (("TR\(defaults.string(forKey: "hostIban") ?? "N/A")"))
        lblHostName.text = defaults.string(forKey: "hostName") ?? "N/A"
    }
    
    private func updateWeatherImage(for weather: Weather) {
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
    
    private func setupCornerRadius(for views: [UIView], radius: CGFloat) {
        views.forEach { view in
            view.layer.cornerRadius = radius
            view.layer.masksToBounds = true
        }
    }
    
    private func setupShowAllPlayersTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAllPlayersTapped))
        lblShowAllPlayers.isUserInteractionEnabled = true
        lblShowAllPlayers.addGestureRecognizer(tapGesture)
    }

    private func setupDraggableViews(for team: [Player], in teamView: UIView) {
      var teamDraggableViews: [PlayerCustomView] = []
      team.forEach { item in
        let view = PlayerCustomView(name: item.name ?? "Unknow", imageName: "kit5", overallScore:   String(item.overall ?? 0))
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
        view.centerYAnchor.constraint(equalTo: teamView.centerYAnchor, constant: -yOffset * 1.1 )
      ])
    }
  }

    private func changeTeam() {
      if teamSegmentedControl.selectedSegmentIndex == 0 {
        firstTeamView.isHidden = false
        secondTeamView.isHidden = true
      } else {
        firstTeamView.isHidden = true
        secondTeamView.isHidden = false
      }
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
        gesture.setTranslation(.zero, in: view)

      } else if gesture.state == .ended {

         let existingConstraints = draggedView.constraints.filter({ $0.identifier == "centerX" || $0.identifier == "centerY" })
          NSLayoutConstraint.deactivate(existingConstraints)
          draggedView.removeConstraints(existingConstraints)

          let centerXConstraint = draggedView.centerXAnchor.constraint(equalTo: superview.leadingAnchor, constant: draggedView.center.x)
          centerXConstraint.identifier = "centerX"
          let centerYConstraint = draggedView.centerYAnchor.constraint(equalTo: superview.topAnchor, constant: draggedView.center.y)
          centerYConstraint.identifier = "centerY"

        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
      }
    }

    @objc private func showAllPlayersTapped() {
        let playerListVC = PlayerListViewController(nibName: "PlayerListViewController", bundle: nil)
        navigationController?.pushViewController(playerListVC, animated: true)
    }

    @IBAction func teamSegmentedControlTapped(_ sender: UISegmentedControl) {
      changeTeam()
    }
}

//MARK: - Extension TableViewDelegate && TableViewDataSource
extension MatchDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks,error) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let placemark = placemarks?.first else {return }
            self.lblLocation.text = [placemark.locality, placemark.administrativeArea].compactMap{ $0 }.joined(separator: ", ")
          viewModel.getWeather(for: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //TODO: Alert eklenecek
        print("Failed to get user location: \(error)")
    }
}

// MARK: - MatchDetailViewModelDelegate

extension MatchDetailViewController: MatchDetailViewModelDelegate {

  func setupUI() {
    viewModel.loadPlayers()
    setupLocationManager()
    loadUserDefaults()
    setupCornerRadius(for: [weatherView, nextMatchView,hostView,playersView], radius: 10)
    setupShowAllPlayersTapGesture()
    changeTeam()
  }

  func configurePlayerData(players: [Player]) {
    lblNumberOfPlayers.text = String(players.count)
    setupDraggableViews(for: players, in: self.firstTeamView)
  }

  func configureWeatherResponse(weatherResponse: WeatherResponse) {
    if let tempInFahrenheit = weatherResponse.main?.temp {
      let tempInCelsius = tempInFahrenheit - 273.15
      lblTemp.text = "\(Int(tempInCelsius))°C"
    }
    if let wind = weatherResponse.wind {
      lblWind.text = "\(Int(wind.speed ?? 700)) km/s"
    }
    if let weather = weatherResponse.weather?.first {
      lblTempDesc.text = weather.description?.capitalized
      updateWeatherImage(for: weather)
    }
  }

}
