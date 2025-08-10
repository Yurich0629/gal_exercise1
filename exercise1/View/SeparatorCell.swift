import UIKit

// MARK: - set separator
class SeparatorCell: UICollectionViewCell {
    static let reuseId = "SeparatorCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
