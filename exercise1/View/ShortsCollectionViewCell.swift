import UIKit

class ShortsCollectionViewCell: UICollectionViewCell {

    static let identifier = "ShortsCollectionViewCell"

    var onShortsItemSelected: ((ShortsItem) -> Void)?

    private var shorts: [ShortsItem] = []

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "shorts_logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }()

    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Shorts"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private let betaImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "beta_icon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        return imageView
    }()

    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 140, height: 240)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with items: [ShortsItem]) {
        self.shorts = items
        collectionView.reloadData()
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ShortsItemCell.self, forCellWithReuseIdentifier: ShortsItemCell.identifier)
    }

    private func setupViews() {
        let textStack = UIStackView()
        textStack.axis = .horizontal
        textStack.spacing = 2
        textStack.alignment = .firstBaseline
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.addArrangedSubview(logoLabel)
        textStack.addArrangedSubview(betaImageView)

        let titleStack = UIStackView()
        titleStack.axis = .horizontal
        titleStack.spacing = 6
        titleStack.alignment = .center
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        titleStack.addArrangedSubview(logoImageView)
        titleStack.addArrangedSubview(textStack)

        headerStack.addArrangedSubview(titleStack)

        contentView.addSubview(headerStack)
        contentView.addSubview(collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionView
extension ShortsCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shorts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShortsItemCell.identifier, for: indexPath) as? ShortsItemCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: shorts[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = shorts[indexPath.item]
        onShortsItemSelected?(selectedItem)
    }
}

