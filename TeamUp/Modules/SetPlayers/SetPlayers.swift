//
//  PlayerViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 6.08.2024.
//

import UIKit

final class SetPlayers: BaseViewController {
    @IBOutlet weak var team1StackView: UIStackView!
    @IBOutlet weak var team2StackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var players = [Player]()
    var initialImage: UIImage?
    var lastRemovedPlayer: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        guard let collectionView = collectionView else {
            fatalError("collectionView outlet is not connected")
        }
        collectionView.register(UINib(nibName: PlayerCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PlayerCollectionViewCell.identifier)
        
        setupStackViews()
        setDragAndDropSettings()
        observePlayers()
    }
    
    private func setupStackViews() {
        updateImageViews(team1StackView, count: 8)
        updateImageViews(team2StackView, count: 8)
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
    
    func updateImageViews(_ stackView: UIStackView, count: Int) {
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
    
    private func createPlayerStackView() -> UIStackView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let playerLabel = UILabel()
        playerLabel.textAlignment = .center
        playerLabel.textColor = .black
        
        let playerStackView = UIStackView(arrangedSubviews: [imageView, playerLabel])
        playerStackView.axis = .vertical
        playerStackView.spacing = 5
        playerStackView.alignment = .center
        
        return playerStackView
    }
    
    private func observePlayers() {
        guard let sportType = UserDefaults.standard.string(forKey: "sportType") else {
            print("Sport type is nil or not set")
            return
        }
        FirebaseService.shared.observePlayer(sportType: sportType) { [weak self] players in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.players = players
                self.collectionView.reloadData()
            }
        }
    }
    @IBAction func btnTakeItBack(_ sender: UIButton) {
        guard let lastRemovedPlayer = lastRemovedPlayer else { return }
        
        // Add the player back to the collection view
        players.append(lastRemovedPlayer)
        collectionView.insertItems(at: [IndexPath(row: players.count - 1, section: 0)])
        
        // Update the UIImageView with the initial image
        clearImageViews(in: team1StackView)
        clearImageViews(in: team2StackView)
    }
    
  @IBAction func goToNextPage(_ sender: UIButton) {
    let matchDetailVC = MatchDetailViewController(nibName: "MatchDetailViewController", bundle: nil)
    navigationController?.pushViewController(matchDetailVC, animated: true)
  }
  
  private func indexPathFor(dragItem: UIDragItem) -> IndexPath? {
        guard let player = dragItem.localObject as? Player else { return nil }
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }
    
    private func clearImageViews(in stackView: UIStackView) {
        for view in stackView.arrangedSubviews {
            guard let columnStackView = view as? UIStackView else { continue }
            for subview in columnStackView.arrangedSubviews {
                if let playerStackView = subview as? UIStackView {
                    for stackSubview in playerStackView.arrangedSubviews {
                        if let imageView = stackSubview as? UIImageView {
                            imageView.image = initialImage
                            imageView.backgroundColor = .lightGray
                        }
                        if let label = stackSubview as? UILabel {
                            label.text = ""
                        }
                    }
                }
            }
        }
    }
}

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

extension SetPlayers: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let destinationView = interaction.view as? UIImageView else { return }
        
        session.loadObjects(ofClass: UIImage.self) { items in
            guard let images = items as? [UIImage], let image = images.first else { return }
            
            DispatchQueue.main.async {
                if self.initialImage == nil {
                    self.initialImage = destinationView.image
                }
                destinationView.image = image
                
                if let dragItem = session.items.first, let indexPath = self.indexPathFor(dragItem: dragItem) {
                    self.lastRemovedPlayer = self.players.remove(at: indexPath.row)
                    self.collectionView.deleteItems(at: [indexPath])
                }
            }
        }
    }
}
