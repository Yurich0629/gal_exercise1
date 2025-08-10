import UIKit

class ShortsPageCell: UICollectionViewCell {
    
    // MARK: - Views
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 18)
        l.textColor = .white
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let channelLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .lightGray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 18
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // buttons
    private let subscribeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Subscribe", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        b.backgroundColor = .systemRed
        b.layer.cornerRadius = 14
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let backButton: UIButton = {
        let b = UIButton(type: .system)
        let img = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        b.setImage(img, for: .normal)
        b.tintColor = .white
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let moreButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(named: "three_dots_icon"), for: .normal)
        b.tintColor = .white
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let likeButton = UIButton(type: .system)
    private let likeCountLabel = UILabel()
    
    private let dislikeButton = UIButton(type: .system)
    private let dislikeLabel = UILabel()
    
    private let commentsButton = UIButton(type: .system)
    private let commentsCountLabel = UILabel()
    
    private let shareButton = UIButton(type: .system)
    private let shareLabel = UILabel()
    
    private let extraButton = UIButton(type: .system)
    
    // callbacks (optional)
    var onBackTapped: (() -> Void)?
    var onLikeTapped: (() -> Void)?
    var onCommentTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?
    
    // gradient
    private let gradientLayer: CAGradientLayer = {
        let g = CAGradientLayer()
        g.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.85).cgColor]
        g.locations = [0.5, 1.0]
        return g
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageView.bounds
    }
    
    // MARK: - Setup
    private func setupViews() {
        // add background image first
        contentView.addSubview(imageView)
        imageView.layer.insertSublayer(gradientLayer, at: 0)
        
        // add controls above imageView
        contentView.addSubview(titleLabel)
        contentView.addSubview(channelLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(subscribeButton)
        contentView.addSubview(backButton)
        
        // prepare right-side stack buttons + labels (they are added inside helper)
        setupRightSideButtons()
        
        // constraints for main layout
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.bottomAnchor.constraint(equalTo: channelLabel.topAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            avatarImageView.widthAnchor.constraint(equalToConstant: 36),
            avatarImageView.heightAnchor.constraint(equalToConstant: 36),
            
            channelLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            channelLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            subscribeButton.leadingAnchor.constraint(equalTo: channelLabel.trailingAnchor, constant: 8),
            subscribeButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            subscribeButton.widthAnchor.constraint(equalToConstant: 98),
            subscribeButton.heightAnchor.constraint(equalToConstant: 28),
        ])
        
        // add targets (IMPORTANT: use method selectors, NOT property names)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(dislikeTapped), for: .touchUpInside)
        commentsButton.addTarget(self, action: #selector(commentsTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        extraButton.addTarget(self, action: #selector(extraTapped), for: .touchUpInside)
        subscribeButton.addTarget(self, action: #selector(subscribeTapped), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
    }
    
    private func setupRightSideButtons() {
        // helper adds button + optional label to contentView
        func createButtonWithLabel(button: UIButton, label: UILabel?, imageName: String, labelText: String?) {
            let img = UIImage(named: imageName)
            button.setImage(img, for: .normal)
            button.tintColor = .white
            button.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(button)
            
            if let lbl = label {
                if let txt = labelText { lbl.text = txt }
                lbl.font = .systemFont(ofSize: 12)
                lbl.textColor = .white
                lbl.textAlignment = .center
                lbl.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(lbl)
            }
        }
        
        // initial label texts (will be overridden for likes/comments in configure)
        createButtonWithLabel(button: likeButton, label: likeCountLabel, imageName: "like_icon", labelText: "0")
        createButtonWithLabel(button: dislikeButton, label: dislikeLabel, imageName: "dislike_icon", labelText: "Dislike")
        createButtonWithLabel(button: commentsButton, label: commentsCountLabel, imageName: "comments_icon", labelText: "0")
        createButtonWithLabel(button: shareButton, label: shareLabel, imageName: "share_icon", labelText: "Share")
        createButtonWithLabel(button: extraButton, label: nil, imageName: "extra_icon", labelText: nil)
        
        // style extra
        extraButton.backgroundColor = UIColor(white: 0.3, alpha: 0.6)
        extraButton.layer.cornerRadius = 6
        extraButton.layer.borderColor = UIColor.white.cgColor
        extraButton.layer.borderWidth = 1
        
        // add "more" button (three dots) as well
        contentView.addSubview(moreButton)
        
        // constraints for right-side vertical stack (kept similar to your layout)
        NSLayoutConstraint.activate([
            // moreButton above likeButton
            moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            moreButton.bottomAnchor.constraint(equalTo: likeButton.topAnchor, constant: -8),
            moreButton.widthAnchor.constraint(equalToConstant: 36),
            moreButton.heightAnchor.constraint(equalToConstant: 36),
            
            // like
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likeButton.bottomAnchor.constraint(equalTo: dislikeButton.topAnchor, constant: -36),
            likeButton.widthAnchor.constraint(equalToConstant: 36),
            likeButton.heightAnchor.constraint(equalToConstant: 36),
            
            likeCountLabel.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),
            likeCountLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 4),
            
            // dislike
            dislikeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dislikeButton.bottomAnchor.constraint(equalTo: commentsButton.topAnchor, constant: -36),
            dislikeButton.widthAnchor.constraint(equalToConstant: 36),
            dislikeButton.heightAnchor.constraint(equalToConstant: 36),
            
            dislikeLabel.centerXAnchor.constraint(equalTo: dislikeButton.centerXAnchor),
            dislikeLabel.topAnchor.constraint(equalTo: dislikeButton.bottomAnchor, constant: 4),
            
            // comments
            commentsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            commentsButton.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -36),
            commentsButton.widthAnchor.constraint(equalToConstant: 36),
            commentsButton.heightAnchor.constraint(equalToConstant: 36),
            
            commentsCountLabel.centerXAnchor.constraint(equalTo: commentsButton.centerXAnchor),
            commentsCountLabel.topAnchor.constraint(equalTo: commentsButton.bottomAnchor, constant: 4),
            
            // share
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            shareButton.bottomAnchor.constraint(equalTo: extraButton.topAnchor, constant: -36),
            shareButton.widthAnchor.constraint(equalToConstant: 36),
            shareButton.heightAnchor.constraint(equalToConstant: 36),
            
            shareLabel.centerXAnchor.constraint(equalTo: shareButton.centerXAnchor),
            shareLabel.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 4),
            
            // extra
            extraButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            extraButton.centerYAnchor.constraint(equalTo: subscribeButton.centerYAnchor),
            extraButton.widthAnchor.constraint(equalToConstant: 36),
            extraButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    // MARK: - Configure
        func configure(with item: ShortsItem, channelName: String, avatarName: String) {
            imageView.image = UIImage(named: item.thumbnailName)
            titleLabel.text = item.title
            channelLabel.text = channelName
            avatarImageView.image = UIImage(named: avatarName)

            // mock random counts to simulate API values
            let likeCount = Int.random(in: 100...10_000)
            let commentsCount = Int.random(in: 10...1_000)
            likeCountLabel.text = formatCount(likeCount)
            commentsCountLabel.text = formatCount(commentsCount)
        }

        private func formatCount(_ count: Int) -> String {
            if count >= 1000 {
                return String(format: "%.1fK", Double(count) / 1000.0)
            } else {
                return "\(count)"
            }
        }

        // MARK: - Actions (print logs)
        @objc private func likeTapped() {
            print("Like button tapped — лайк для шортса \"\(titleLabel.text ?? "")\"")
            onLikeTapped?()
        }

        @objc private func dislikeTapped() {
            print("Dislike button tapped")
        }

        @objc private func commentsTapped() {
            print("Comments button tapped — открыть комментарии")
            onCommentTapped?()
        }

        @objc private func shareTapped() {
            print("Share button tapped — поделиться шортсом")
            onShareTapped?()
        }

        @objc private func extraTapped() {
            print("Extra button tapped — доп. меню")
        }

        @objc private func moreTapped() {
            print("More options tapped")
        }

        @objc private func subscribeTapped() {
            print("Subscribe button tapped — подписаться на канал")
        }

        @objc private func backTapped() {
            print("Back tapped — закрыть шортс")
            onBackTapped?()
        }
    }
