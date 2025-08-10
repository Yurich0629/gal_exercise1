import UIKit

final class HomeViewController: UIViewController {
    // MARK: - Properties
    private var videos: [VideoItem] = []
    private var filteredVideos: [VideoItem] = []
    private var shorts: [ShortsItem] = []
    private var filteredShorts: [ShortsItem] = []
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupExploreFilters()
        setupCollectionView()
        loadFakeData()
    }
    
    // MARK: - navigation bar
    
    private func setupNavigationBar() {
        self.navigationItem.title = ""
        
        let logoImageView = UIImageView(image: UIImage(named: "youtube_logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        let logoItem = UIBarButtonItem(customView: logoImageView)
        self.navigationItem.leftBarButtonItem = logoItem
        
        func makeButton(imageName: String, size: CGFloat = 28, actionName: String) -> UIBarButtonItem {
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: imageName), for: .normal)
            button.tintColor = .label
            button.frame = CGRect(x: 0, y: 0, width: size, height: size)
            button.contentEdgeInsets = .zero
            button.addAction(UIAction(handler: { _ in
                print("\(actionName) button tapped")
            }), for: .touchUpInside)
            return UIBarButtonItem(customView: button)
        }
        
        // MARK: - buttons
        
        let avatarButton = UIButton(type: .system)
        let avatarImage = UIImage(named: "mock_profile")?.withRenderingMode(.alwaysOriginal)
        avatarButton.setImage(avatarImage, for: .normal)
        avatarButton.layer.cornerRadius = 14
        avatarButton.clipsToBounds = true
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        avatarButton.addAction(UIAction(handler: { _ in
            print("Avatar tapped")
        }), for: .touchUpInside)

        let avatarItem = UIBarButtonItem(customView: avatarButton)
        
        let searchItem = makeButton(imageName: "search_icon", actionName: "Search")
        let bellItem = makeButton(imageName: "bell_icon", actionName: "Bell")
        let castItem = makeButton(imageName: "cast_icon", actionName: "Cast")
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -8
        
        self.navigationItem.rightBarButtonItems = [
            avatarItem,
            negativeSpacer,
            searchItem,
            negativeSpacer,
            bellItem,
            negativeSpacer,
            castItem
        ]
    }
    
    private var filtersBottomAnchor: NSLayoutYAxisAnchor!
    
    private func setupExploreFilters() {
        let container = UIStackView()
        container.axis = .horizontal
        container.alignment = .center
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            container.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let exploreIcon = UIImageView(image: UIImage(named: "explore_icon"))
        exploreIcon.contentMode = .scaleAspectFit
        exploreIcon.translatesAutoresizingMaskIntoConstraints = false
        exploreIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        exploreIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let exploreLabel = UILabel()
        exploreLabel.text = "Explore"
        exploreLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        exploreLabel.textColor = .label
        
        let exploreWrapper = UIStackView(arrangedSubviews: [exploreIcon, exploreLabel])
        exploreWrapper.axis = .horizontal
        exploreWrapper.spacing = 6
        exploreWrapper.alignment = .center
        exploreWrapper.layoutMargins = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        exploreWrapper.isLayoutMarginsRelativeArrangement = true
        exploreWrapper.backgroundColor = UIColor.systemGray5
        exploreWrapper.layer.cornerRadius = 8
        exploreWrapper.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = UIView()
        separator.backgroundColor = .systemGray3
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.widthAnchor.constraint(equalToConstant: 2).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let filtersStack = UIStackView()
        filtersStack.axis = .horizontal
        filtersStack.spacing = 4
        filtersStack.translatesAutoresizingMaskIntoConstraints = false
        
        let filters = ["All", "Mixes", "Music", "Graphic"]
        
        for filter in filters {
            let button = UIButton(type: .system)
            button.setTitle(filter, for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
            button.layer.cornerRadius = 16
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.backgroundColor = filter == "All" ? UIColor.systemGray5 : UIColor.clear
            
            button.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                
                print("Filter '\(filter)' tapped")
                
                for case let b as UIButton in filtersStack.arrangedSubviews {
                    b.backgroundColor = .clear
                }
                button.backgroundColor = UIColor.systemGray5
                
                if filter == "All" {
                    self.filteredShorts = self.shorts
                    self.filteredVideos = self.videos
                } else {
                    self.filteredShorts = self.shorts.filter { $0.category == filter }
                    self.filteredVideos = self.videos.filter { $0.category == filter }
                }
                
                self.collectionView.reloadData()
            }), for: .touchUpInside)
            
            filtersStack.addArrangedSubview(button)
        }
        
        scrollView.addSubview(filtersStack)
        
        container.addArrangedSubview(exploreWrapper)
        container.setCustomSpacing(24, after: exploreWrapper)
        container.addArrangedSubview(separator)
        container.setCustomSpacing(24, after: separator)
        container.addArrangedSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalToConstant: 36),
            filtersStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            filtersStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            filtersStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            filtersStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            filtersStack.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        filtersBottomAnchor = container.bottomAnchor
    }
    
    private func getFiltersBottomAnchor() -> NSLayoutYAxisAnchor {
        return filtersBottomAnchor ?? view.safeAreaLayoutGuide.topAnchor
    }
    
    private func setupCollectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 12
            layout.sectionInset = .zero

            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .systemBackground

            collectionView.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.reuseId)
            collectionView.register(ShortsCollectionViewCell.self, forCellWithReuseIdentifier: ShortsCollectionViewCell.identifier)
            collectionView.register(SeparatorCell.self, forCellWithReuseIdentifier: SeparatorCell.reuseId)

            collectionView.dataSource = self
            collectionView.delegate = self

            view.addSubview(collectionView)

            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: getFiltersBottomAnchor(), constant: 8),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    
    // MARK: - mock data

        private func loadFakeData() {
            videos = [
                VideoItem(thumbnailName: "main_image", avatarName: "avatarka", title: "Amazing SwiftUI Tutorial", dateAndViews: "3 days ago • 1.2M views", category: "Music"),
                VideoItem(thumbnailName: "main_image", avatarName: "avatarka", title: "fjdkgjkjgkf jdfkdfj 56", dateAndViews: "1 week ago • 132K views", category: "Graphic"),
                VideoItem(thumbnailName: "main_image", avatarName: "avatarka", title: "How  a Chat App", dateAndViews: "1 week ago • 232K views", category: "Mixes"),
                VideoItem(thumbnailName: "main_image", avatarName: "avatarka", title: "How to build", dateAndViews: "1 week ago • 332K views", category: "Music"),
                VideoItem(thumbnailName: "main_image", avatarName: "avatarka", title: "clfmgldl kdkfdkfk kfkf App", dateAndViews: "1 week ago • 432K views", category: "Graphic"),
                VideoItem(thumbnailName: "main_image", avatarName: "avatarka", title: "Hbuild a Chat App", dateAndViews: "1 week ago • 532K views", category: "Mixes"),
                VideoItem(thumbnailName: "main_image", avatarName: "avatarka", title: "Howgfggfdcdg 89 ffff ", dateAndViews: "1 week ago • 632K views", category: "Music"),
                VideoItem(thumbnailName: "main_image", avatarName: "avatarka", title: " KJGFKFDKGFDJGDFGJKFKF", dateAndViews: "1 week ago • 732K views", category: "Graphic"),
            ]

            shorts = [
                ShortsItem(thumbnailName: "music1", title: "Funny Cats", views: "1.2M views", category: "Music"),
                ShortsItem(thumbnailName: "gr1", title: "Swift Tricks", views: "980K views", category: "Graphic"),
                ShortsItem(thumbnailName: "mixing2", title: "iOS Development", views: "700K views", category: "Mixes"),
                ShortsItem(thumbnailName: "music2", title: "Travel Vlog", views: "500K views", category: "Music"),
                ShortsItem(thumbnailName: "gr2", title: "Cooking Tips", views: "345K views", category: "Graphic"),
                ShortsItem(thumbnailName: "mixing2", title: "Cooking Tips", views: "999K views", category: "Mixes"),
                ShortsItem(thumbnailName: "music3", title: "Cooking Tips", views: "956K views", category: "Music"),
                ShortsItem(thumbnailName: "gr3", title: "Cooking Tips", views: "111K views", category: "Graphic")
            ]

            filteredShorts = shorts
            filteredVideos = videos

            collectionView.reloadData()
        }
    }

    // MARK: - UICollectionView

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return filteredVideos.count
        case 1: return 1
        case 2: return 1
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.reuseId, for: indexPath) as! VideoCell
            cell.configure(with: filteredVideos[indexPath.item])
            return cell

        case 1:
            let separatorCell = collectionView.dequeueReusableCell(withReuseIdentifier: SeparatorCell.reuseId, for: indexPath)
            separatorCell.backgroundColor = .systemGray3
            return separatorCell

        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortsCollectionViewCell.identifier, for: indexPath) as! ShortsCollectionViewCell
            cell.configure(with: filteredShorts)
            cell.onShortsItemSelected = { [weak self] selectedShorts in
                guard let self = self else { return }
                if let index = self.filteredShorts.firstIndex(where: {
                    $0.thumbnailName == selectedShorts.thumbnailName && $0.title == selectedShorts.title
                }) {
                    print("Selected shorts: '\(selectedShorts.title)' at index \(index)")
                    let fullscreenVC = ShortsFullscreenViewController()
                    fullscreenVC.shortsItems = self.filteredShorts
                    fullscreenVC.initialIndex = index
                    fullscreenVC.modalPresentationStyle = .fullScreen
                    self.present(fullscreenVC, animated: true)
                }
            }
            return cell

        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let video = filteredVideos[indexPath.item]
            print("Selected video: '\(video.title)'")
        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        switch indexPath.section {
        case 0: return CGSize(width: width, height: 230)
        case 1: return CGSize(width: width, height: 4)
        case 2: return CGSize(width: width, height: 280)
        default: return .zero
        }
    }
}
