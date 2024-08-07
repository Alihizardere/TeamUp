//
//  PlayerViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 6.08.2024.
//

import UIKit

final class SetPlayers: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var team1StackView: UIStackView!
    @IBOutlet weak var team2StackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: - Properties
    private var players = [Player]()
    private var initialImage: UIImage?
    private var lastRemovedPlayer: Player?
    private var lastAddedImageView: UIImageView?
    private var addedPlayersHistory: [(player: Player, imageView: UIImageView)] = []
    fileprivate var firebaseService: FirebaseServiceProtocol = FirebaseService()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: PlayerCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PlayerCollectionViewCell.identifier)
        setupStackViews()
        setDragAndDropSettings()
        observePlayers()
    }
    
    //MARK: - Private Functions
    private func setupStackViews() {
        updateImageViews(team1StackView, count: 6)
        updateImageViews(team2StackView, count: 6)
    }
    
    private func setDragAndDropSettings() {
        setupDragAndDropForStackView(team1StackView)
        setupDragAndDropForStackView(team2StackView)
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
    }
    
    private func setupDragAndDropForStackView(_ stackView: UIStackView) {
        for view in stackView.arrangedSubviews {
            guard let columnStackView = view as? UIStackView else { continue }
            for subview in columnStackView.arrangedSubviews {
                if let playerStackView = subview as? UIStackView, let imageView = playerStackView.arrangedSubviews.first as? UIImageView {
                    imageView.isUserInteractionEnabled = true
                    let dropInteraction = UIDropInteraction(delegate: self)
                    imageView.addInteraction(dropInteraction)
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
        
        let playerStackView = UIStackView(arrangedSubviews: [imageView, playerLabel])
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
    
    private func observePlayers() {
        
        guard let sportType = UserDefaults.standard.string(forKey: "sportType") else { return }
        firebaseService.fetchPlayers(sportType: sportType) { [weak self] players in
            guard let self else { return }
            DispatchQueue.main.async {
                self.players = players
                self.collectionView.reloadData()
                
            }
        }
    }
    
    private func indexPathFor(dragItem: UIDragItem) -> IndexPath? {
        guard let player = dragItem.localObject as? Player else { return nil }
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }
    
    private func clearLastRemovedImageView() {
        for stackView in [team1StackView, team2StackView] {
            guard let stackView = stackView else { continue }
            for view in stackView.arrangedSubviews {
                guard let columnStackView = view as? UIStackView else { continue }
                for subview in columnStackView.arrangedSubviews {
                    if let playerStackView = subview as? UIStackView {
                        for stackSubview in playerStackView.arrangedSubviews {
                            if let imageView = stackSubview as? UIImageView, let image = imageView.image, image == UIImage(named: "kit5") {
                                imageView.image = initialImage
                                if let label = playerStackView.arrangedSubviews.last as? UILabel, label.text == lastRemovedPlayer?.name {
                                    label.text = ""
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Button Actions
    @IBAction func btnTakeItBack(_ sender: UIButton) {
        guard !addedPlayersHistory.isEmpty else { return }
        
        // Get the last added player and imageView from the history
        let lastAdded = addedPlayersHistory.removeLast()
        
        players.append(lastAdded.player)
        collectionView.insertItems(at: [IndexPath(row: players.count - 1, section: 0)])
        
        lastAdded.imageView.image = initialImage
        
        // Clear the player label text
        if let playerStackView = lastAdded.imageView.superview as? UIStackView {
            let playerLabel = playerStackView.arrangedSubviews.last as? UILabel
            playerLabel?.text = ""
        }
    }
    
    @IBAction func goToNextPage(_ sender: UIButton) {
        let matchDetailVC = MatchDetailViewController(nibName: "MatchDetailViewController", bundle: nil)
        navigationController?.pushViewController(matchDetailVC, animated: true)
    }
}

//MARK: - Extension UICollectionViewDelegate, UICollectionViewDataSource
extension SetPlayers: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerCollectionViewCell.identifier, for: indexPath) as? PlayerCollectionViewCell else {
            fatalError("Failed to dequeue PlayerCollectionViewCell")
        }
        let player = players[indexPath.row]
        cell.configure(with: player)
        return cell
    }
}

//MARK: - Extension UICollectionViewDragDelegate
extension SetPlayers: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let player = players[indexPath.row]
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

//MARK: - Extension UIDropInteractionDelegate
extension SetPlayers: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let destinationView = interaction.view as? UIImageView else { return }
        let playerStackView = destinationView.superview as? UIStackView
        let playerLabel = playerStackView?.arrangedSubviews.last as? UILabel
        
        session.loadObjects(ofClass: UIImage.self) { items in
            guard let images = items as? [UIImage], let image = images.first else { return }
            
            DispatchQueue.main.async {
                if self.initialImage == nil {
                    self.initialImage = destinationView.image
                }
                destinationView.image = image
                
                if let dragItem = session.items.first, let indexPath = self.indexPathFor(dragItem: dragItem) {
                    let removedPlayer = self.players.remove(at: indexPath.row)
                    self.collectionView.deleteItems(at: [indexPath])
                    self.addedPlayersHistory.append((player: removedPlayer, imageView: destinationView))
                    
                    // Update the playerLabel with the player's name
                    playerLabel?.text = (removedPlayer.name ?? "") + " " + (removedPlayer.surname ?? "")
                }
            }
        }
    }
}
