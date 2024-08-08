//
//  PlayerViewController.swift
//  TeamUp
//
//  Created by Doğukan Temizyürek on 6.08.2024.
//
import UIKit

final class SetPlayersViewController: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var team1StackView: UIStackView!
    @IBOutlet weak var team2StackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!

    //MARK: - Properties
    private var initialImage: UIImage?
    private var addedPlayersHistory: [(player: Player, imageView: UIImageView)] = []
    var viewModel: SetPlayersViewModelProtocol! {
        didSet { viewModel.delegate = self }
    }
    var gameType: String?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackViews()
        setDragAndDropSettings()
        viewModel = SetPlayersViewModel()
        viewModel.viewDidLoad()
    }

    //MARK: - Private Functions
    private func setupStackViews() {
        if let gameType = gameType, let playerCount = Int(gameType) {
            updateImageViews(team1StackView, count: playerCount)
            updateImageViews(team2StackView, count: playerCount)
        } else {
            updateImageViews(team1StackView, count: 6)
            updateImageViews(team2StackView, count: 6)
        }
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

    private func indexPathFor(dragItem: UIDragItem) -> IndexPath? {
        guard let player = dragItem.localObject as? Player else { return nil }
        if let index = viewModel.players.firstIndex(where: { $0.id == player.id }) {
            return IndexPath(row: index, section: 0)
        }
        return nil
    }

    //MARK: - Button Actions
    @IBAction func btnTakeItBack(_ sender: UIButton) {
        guard let lastAdded = addedPlayersHistory.popLast() else { return }
        lastAdded.imageView.image = initialImage

        // Clear the player label text
        if let playerStackView = lastAdded.imageView.superview as? UIStackView {
            let playerLabel = playerStackView.arrangedSubviews.last as? UILabel
            playerLabel?.text = ""
        }
        
        viewModel.undoLastPlayerAddition()
    }

    @IBAction func goToNextPage(_ sender: UIButton) {
        let matchDetailVC = MatchDetailViewController(nibName: "MatchDetailViewController", bundle: nil)
        navigationController?.pushViewController(matchDetailVC, animated: true)
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
        let playerLabel = playerStackView?.arrangedSubviews.last as? UILabel

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
                        playerLabel?.text = "\(removedPlayer.name ?? "") \(removedPlayer.surname ?? "")"
                    }
                }
            }
        }
    }
}

//MARK: - SetPlayersViewModelDelegate
extension SetPlayersViewController: SetPlayersViewModelDelegate {
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

    func setupUI() {
        collectionView.register(UINib(nibName: PlayerCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PlayerCollectionViewCell.identifier)
        guard let sportType = UserDefaults.standard.string(forKey: "sportType") else { return }
        viewModel.loadPlayers(for: sportType)
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

