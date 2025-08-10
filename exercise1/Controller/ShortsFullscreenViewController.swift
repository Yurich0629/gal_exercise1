import UIKit

final class ShortsFullscreenViewController: UIViewController {
    var shortsItems: [ShortsItem] = []
    var initialIndex: Int = 0

    private let mockChannelName = "SADEK Tuts"
    private let mockAvatarName = "avtor" 

    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        view.backgroundColor = .black
        scrollToInitialItem()
        logShortsOpen()
        
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ShortsPageCell.self, forCellWithReuseIdentifier: "ShortsPageCell")

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func scrollToInitialItem() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: self.initialIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    private func logShortsOpen() {
        print("shorts at index \(initialIndex) opened")
    }
}

extension ShortsFullscreenViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shortsItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = shortsItems[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShortsPageCell", for: indexPath) as! ShortsPageCell
        cell.configure(with: item, channelName: mockChannelName, avatarName: mockAvatarName)
        
        cell.onBackTapped = { [weak self] in
            print("back button was tapped on shorts at index \(indexPath.item)")
            self?.dismiss(animated: true)
        }
        
        cell.onLikeTapped = {
            print("like button was tapped on shorts at index \(indexPath.item)")
        }
        
        cell.onCommentTapped = {
            print("comment button was tapped on shorts at index \(indexPath.item)")
        }
        
        cell.onShareTapped = {
            print("share button was tapped on shorts at index \(indexPath.item)")
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
