import UIKit

class ShortsItemCell: UICollectionViewCell {
    
    static let identifier = "ShortsItemCell"

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.6).cgColor]
        gradient.locations = [0.6, 1.0]
        return gradient
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.addSubview(titleLabel)
        imageView.addSubview(viewsLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: viewsLabel.topAnchor, constant: -4),

            viewsLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
            viewsLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            viewsLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        gradientLayer.frame = imageView.bounds
        if gradientLayer.superlayer == nil {
            imageView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: ShortsItem) {
        imageView.image = UIImage(named: item.thumbnailName)
        titleLabel.text = item.title
        viewsLabel.text = item.views
    }
}
