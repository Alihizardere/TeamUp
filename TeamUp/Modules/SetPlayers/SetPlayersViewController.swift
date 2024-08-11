//
//  PlayerViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 6.08.2024.
//
import UIKit

final class SetPlayersViewController: BaseViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var team1StackView: UIStackView!
    @IBOutlet weak var team2StackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - PROPERTIES
    private var initialImage: UIImage?
    private var addedPlayersHistory: [(player: Player, imageView: UIImageView)] = []
    private var viewModel: SetPlayersViewModelProtocol! {
        didSet { viewModel.delegate = self }
    }
    var gameType: String?
    
    //MARK: -  LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackViews()
        setDragAndDropSettings()
        viewModel = SetPlayersViewModel()
        viewModel.viewDidLoad()
    }
    
    //MARK: - PRIVATE FUNCTIONS
    
    private func setupStackViews() {
        if let gameType = gameType, let playerCount = Int(gameType) {
            print(gameType)
            updateImageViews(team1StackView, count: playerCount)
            updateImageViews(team2StackView, count: playerCount)
        } else {
            updateImageViews(team1StackView, count: 6)
            updateImageViews(team2StackView, count: 6)
        }
    }
    
    private func setupDragAndDropForStackView(_ stackView: UIStackView) {
        processStackView(stackView) { imageView, _ in
            imageView.isUserInteractionEnabled = true
            let dropInteraction = UIDropInteraction(delegate: self)
            imageView.addInteraction(dropInteraction)
        }
    }
    
    private func setDragAndDropSettings() {
        setupDragAndDropForStackView(team1StackView)
        setupDragAndDropForStackView(team2StackView)
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
    }
    
    private func processStackView(_ stackView: UIStackView, action: (UIImageView, UILabel) -> Void) {
        for view in stackView.arrangedSubviews {
            guard let columnStackView = view as? UIStackView else { continue }
            for subview in columnStackView.arrangedSubviews {
                if let playerStackView = subview as? UIStackView,
                   let imageView = playerStackView.arrangedSubviews.first as? UIImageView,
                   let playerLabel = playerStackView.arrangedSubviews.last as? UILabel {
                    action(imageView, playerLabel)
                }
            }
        }
    }
    
    private func createColumnStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }
    
    private func createPlayerStackView() -> UIStackView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        imageView.image = UIImage(named: "kit1")
        
        let playerLabel = UILabel()
        playerLabel.textAlignment = .center
        playerLabel.textColor = .black
        playerLabel.numberOfLines = 1
        playerLabel.adjustsFontSizeToFitWidth = true
        playerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let positionLabel = UILabel()
        positionLabel.adjustsFontSizeToFitWidth = true
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let overallLabel = UILabel()
        overallLabel.adjustsFontSizeToFitWidth = true
        overallLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let playerStackView = UIStackView(arrangedSubviews: [imageView,  positionLabel, overallLabel, playerLabel])
        playerStackView.axis = .vertical
        playerStackView.spacing = 5
        playerStackView.alignment = .center
        playerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        playerLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        playerLabel.widthAnchor.constraint(equalTo: playerStackView.widthAnchor).isActive = true
        
        return playerStackView
    }
    
    private func updateImageViews(_ stackView: UIStackView, count: Int) {
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        let firstColumnStackView = createColumnStackView()
        let secondColumnStackView = createColumnStackView()
        
        for index in 0..<count {
            let playerStackView = createPlayerStackView()
            let targetStackView = (index % 2 == 0) ? firstColumnStackView : secondColumnStackView
            targetStackView.addArrangedSubview(playerStackView)
        }
        
        stackView.addArrangedSubview(firstColumnStackView)
        stackView.addArrangedSubview(secondColumnStackView)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
    }
    
    private func indexPathFor(dragItem: UIDragItem) -> IndexPath? {
        guard let player = dragItem.localObject as? Player else { return nil }
        if let index = viewModel.players.firstIndex(where: { $0.id == player.id }) {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }
    
    private func getPlayersFromStackView(_ stackView: UIStackView) -> [Player] {
        var players: [Player] = []
        
        for view in stackView.arrangedSubviews {
            guard let columnStackView = view as? UIStackView else { continue }
            for subview in columnStackView.arrangedSubviews {
                if let playerStackView = subview as? UIStackView {
                    let playerLabel = playerStackView.arrangedSubviews[3] as? UILabel
                    let positionLabel = playerStackView.arrangedSubviews[1] as? UILabel
                    let overallLabel = playerStackView.arrangedSubviews[2] as? UILabel
                    
                    let playerName = playerLabel?.text
                    let position = positionLabel?.text
                    let overall = overallLabel?.text ?? "0"
                    
                    let player = Player(
                        id: UUID().uuidString,
                        name: playerName,
                        surname: nil,
                        imageUrl: nil,
                        position: position,
                        overall: Int(overall)
                    )
                    players.append(player)
                }
            }
        }
        return players
    }
    
    private func areAllPositionsFilled() -> Bool {
        var allFilled = true
        for stackView in [team1StackView, team2StackView] {
            processStackView(stackView!) { _, playerLabel in
                if playerLabel.text?.isEmpty ?? true {
                    allFilled = false
                }
            }
        }
        return allFilled
    }
    
    private func resetStackViewImages(_ stackView: UIStackView) {
        processStackView(stackView) { imageView, playerLabel in
            imageView.image = UIImage(named: "kit1")
            playerLabel.text = ""
        }
    }
    
    private func clearStackViews() {
        team1StackView.arrangedSubviews.forEach { view in
            team1StackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        team2StackView.arrangedSubviews.forEach { view in
            team2StackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        addedPlayersHistory.removeAll()
    }
    
    //MARK: - ACTIONS
    
    @IBAction func btnTakeItBack(_ sender: UIButton) {
        guard let lastAdded = addedPlayersHistory.popLast() else { return }
        lastAdded.imageView.image = initialImage
        
        if let playerStackView = lastAdded.imageView.superview as? UIStackView {
            let playerLabel = playerStackView.arrangedSubviews.last as? UILabel
            playerLabel?.text = ""
        }
        
        viewModel.undoLastPlayerAddition()
    }
    
    @IBAction func btnClearAll(_ sender: UIButton) {
        resetStackViewImages(team1StackView)
        resetStackViewImages(team2StackView)
        viewModel.restoreAllPlayers()
    }
    
    
    @IBAction func goToNextPage(_ sender: UIButton) {
        if !areAllPositionsFilled() {
            UIAlertController.showAlert(
                on: self,
                title:  "Incomplete Team" ,
                message: "Please fill all player positions before proceeding.",
                primaryButtonTitle: "OK",
                primaryButtonStyle: .default
            )
        } else {
            let matchDetailVC = MatchDetailViewController(nibName: "MatchDetailViewController", bundle: nil)
            let team1Players = getPlayersFromStackView(team1StackView)
            let team2Players = getPlayersFromStackView(team2StackView)
            matchDetailVC.team1Players = team1Players
            matchDetailVC.team2Players = team2Players
            
            navigationController?.pushViewController(matchDetailVC, animated: true)
        }
        
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SetPlayersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerCollectionViewCell.identifier, for: indexPath) as? PlayerCollectionViewCell else { return UICollectionViewCell() }
        if let player = viewModel.player(at: indexPath) {
            cell.configure(with: player)
        }
        return cell
    }
}

//MARK: - UICollectionViewDragDelegate

extension SetPlayersViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let player = viewModel.players[indexPath.row]
        if let image = UIImage(named: "kit5") {
            let itemProvider = NSItemProvider(object: image)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = player
            return [dragItem]
        } else {
            return []
        }
    }
}

//MARK: - UIDropInteractionDelegate

extension SetPlayersViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let destinationView = interaction.view as? UIImageView else { return }
        let playerStackView = destinationView.superview as? UIStackView
        let playerLabel = playerStackView?.arrangedSubviews[3] as? UILabel // Player name
        let positionLabel = playerStackView?.arrangedSubviews[1] as? UILabel // Position
        let overallLabel = playerStackView?.arrangedSubviews[2] as? UILabel // Overall
        
        session.loadObjects(ofClass: UIImage.self) { items in
            guard let images = items as? [UIImage], let image = images.first else { return }
            
            DispatchQueue.main.async {
                if self.initialImage == nil {
                    self.initialImage = destinationView.image
                }
                destinationView.image = image
                
                if let dragItem = session.items.first, let indexPath = self.indexPathFor(dragItem: dragItem) {
                    if let removedPlayer = self.viewModel.removePlayer(at: indexPath.row) {
                        self.collectionView.deleteItems(at: [indexPath])
                        self.addedPlayersHistory.append((player: removedPlayer, imageView: destinationView))
                        
                        // Set the player's information
                        playerLabel?.text = "\(removedPlayer.name ?? "")"
                        positionLabel?.text = removedPlayer.position
                        overallLabel?.text = "\(removedPlayer.overall ?? 0)"
                    }
                }
            }
        }
    }
    
    
}

//MARK: - SetPlayersViewModelDelegate

extension SetPlayersViewController: SetPlayersViewModelDelegate {
    
    func setupUI() {
        collectionView.register(UINib(nibName: PlayerCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PlayerCollectionViewCell.identifier)
        guard let sportType = UserDefaults.standard.string(forKey: Constants.SportType.key) else { return }
        viewModel.loadPlayers(for: sportType)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showEmptyView() {
        self.collectionView.setEmptyView(
            title: "No Players Yet",
            message: "Add new players to get started!",
            image: UIImage(named: "no-results")
        )
    }
    
    func hideEmptyView() {
        self.collectionView.restore()
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func showErrorAlert() {
        UIAlertController.showAlert(
            on: self,
            title: "Delete",
            message: "Deletion failed, try again."
        )
    }
}

