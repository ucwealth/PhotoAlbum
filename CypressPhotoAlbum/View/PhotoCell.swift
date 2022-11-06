
import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    static let identifier = Constants.HorizontalCellID
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageBox)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    lazy var imageBox: UIImageView = {
        let image = UIImageView()
        image.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        imageBox.kf.setImage(with: url)
    }
    
}
