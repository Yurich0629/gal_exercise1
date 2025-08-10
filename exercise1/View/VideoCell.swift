import UIKit

class VideoCell: UICollectionViewCell {
    static let reuseId = "VideoCell"
    
    private let thumbnailImageView = UIImageView()
    private let avatarImageView = UIImageView()
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupViews() {
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infoLabel.font = UIFont.systemFont(ofSize: 12)
        infoLabel.textColor = .secondaryLabel
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, infoLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 4
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomStack = UIStackView(arrangedSubviews: [avatarImageView, labelsStack])
        bottomStack.axis = .horizontal
        bottomStack.alignment = .center
        bottomStack.spacing = 8
        bottomStack.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        bottomStack.isLayoutMarginsRelativeArrangement = true
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(bottomStack)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 180),
            
            bottomStack.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor),
            bottomStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with item: VideoItem) {
        thumbnailImageView.image = UIImage(named: item.thumbnailName)
        avatarImageView.image = UIImage(named: item.avatarName)
        titleLabel.text = item.title
        infoLabel.text = item.dateAndViews
    }
}

